// HTTP Server that ingests analytics data from clients + writes to Cloud SQL
// Source: https://www.golangprograms.com/example-to-handle-get-and-post-request-in-golang.html
package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"os"

	"github.com/gofrs/uuid"
	"github.com/gorilla/mux"
	log "github.com/sirupsen/logrus"

	_ "github.com/jackc/pgx/v4/stdlib"
)

// app struct contains global state for Cloud SQL.
type app struct {
	db *sql.DB
}

// Represents 1 GKE cluster created during 1 run of `gkekitctl create` by 1 user
type Cluster struct {
	// SERVER GENERATES THESE. They will be empty on POST.
	ClusterId string `json:"clusterId"`
	CreateId  string `json:"createId"`

	// The rest of these fields must be populated by the client on POST.
	//String Format: 2006-01-02T15:04:05.000Z		Test string: 2021-11-12T11:45:26.371Z
	Timestamp string `json:"timestamp"`
	OS        string `json:"os"`

	// Info about this create run + all clusters in that create run
	TerraformState            string `json:"terraformState"`
	Region                    string `json:"region"`
	EnableWorkloadIdentity    bool   `json:"enableWorkloadIdentity"`
	EnablePreemptibleNodepool bool   `json:"enablePreemptibleNodepool"`
	DefaultNodepoolOS         string `json:"defaultNodepoolOS"`
	PrivateEndpoint           bool   `json:"privateEndpoint"`
	EnableConfigSync          bool   `json:"enableConfigSync"`
	EnablePolicyController    bool   `json:"enablePolicyController"`
	VPCType                   string `json:"vpcType"`

	// Info about this specific cluster within that create run
	ClusterIndex       int    `json:"clusterIndex"`
	ClusterNumNodes    int    `json:"clusterNumNodes"`
	ClusterType        string `json:"clusterType"`
	ClusterMachineType string `json:"clusterMachineType"`
	ClusterRegion      string `json:"clusterRegion"`
	ClusterZone        string `json:"clusterZone"`
}

var a *app

// Starts the webserver on port 8000.
// Server has a single endpoint - POST / - which accepts a JSON object
func main() {
	// initialize cloud SQL client
	var err error
	a, err = initCloudSQL()
	if err != nil {
		log.Fatal(err)
	}

	// Start web server
	r := mux.NewRouter()

	r.HandleFunc("/", a.ReceiveClusterAndWriteToSQL).Methods("POST")
	srv := &http.Server{
		Handler:      r,
		Addr:         "0.0.0.0:8000",
		WriteTimeout: 5 * time.Second,
		ReadTimeout:  5 * time.Second,
	}

	log.Info("📊 GKE PoC Toolkit Analytics: Starting server on port 8000")
	log.Fatal(srv.ListenAndServe())
}

// HANDLER
// Get POST request from CLI client and write it to Cloud SQL
func (app *app) ReceiveClusterAndWriteToSQL(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		w.WriteHeader(http.StatusMethodNotAllowed)
		w.Write([]byte("Method not allowed."))
		return
	}
	// Read incoming JSON POST into Go struct
	var c Cluster
	decoder := json.NewDecoder(r.Body)
	err := decoder.Decode(&c)
	if err != nil {
		log.Error(err)
	}
	defer r.Body.Close()

	// Validate request
	if err := validateRequest(c); err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(err.Error()))
	}

	// Assign UUIDs to create run and cluster
	createId, err := uuid.NewV4()
	if err != nil {
		log.Error(err)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
	}
	c.CreateId = createId.String()
	clusterId, err := uuid.NewV4()
	if err != nil {
		log.Error(err)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
	}
	c.ClusterId = clusterId.String()

	// Log received cluster
	log.Infof("Received cluster: ID: %s, timestamp: %s, OS: %s", c.ClusterId, c.Timestamp, c.OS)

	// Write to Cloud SQL
	// TODO - make async?
	if err := writeToCloudSQL(app, c); err != nil {
		log.Error(err)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
	}

	// Give back what the user sent + status 200
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(c)
	return
}

func validateRequest(c Cluster) error {
	// Validate timestamp
	// https://stackoverflow.com/questions/25845172/parsing-date-string-in-go
	layout := "2006-01-02T15:04:05.000Z"
	_, err := time.Parse(layout, c.Timestamp)
	if err != nil {
		return fmt.Errorf("Invalid timestamp: %v", err)
	}

	// Cluster fields must be populated
	if c.ClusterNumNodes < 1 {
		return fmt.Errorf("Cluster Num Nodes is empty")
	}
	if c.ClusterMachineType == "" {
		return fmt.Errorf("Cluster Machine Type is empty")
	}
	if c.ClusterRegion == "" {
		return fmt.Errorf("Cluster Region is empty")
	}

	return nil
}

// Init Cloud SQL and ensure Cluster Table exists in Database `analytics`
// Source: https://github.com/GoogleCloudPlatform/golang-samples/blob/6c46053696035e0b5d210806f005c43da9bcb6ee/cloudsql/postgres/database-sql/cloudsql.go
func initCloudSQL() (*app, error) {
	var err error
	a := &app{}

	if os.Getenv("DB_HOST") != "" {
		a.db, err = initTCPConnectionPool()
		if err != nil {
			log.Fatalf("initTCPConnectionPool: unable to connect: %s", err)
		}
	} else {
		a.db, err = initSocketConnectionPool()
		if err != nil {
			log.Fatalf("initSocketConnectionPool: unable to connect: %s", err)
		}
	}

	tableCreate := `
	CREATE TABLE TESTCLUSTER(
		CLUSTERID TEXT 			PRIMARY KEY     NOT NULL,
		CLUSTERMACHINETYPE      TEXT    NOT NULL,
		ENABLECONFIGSYNC        BOOL
	 );`

	// Create the Cluster table if it does not already exist.
	if _, err = a.db.Exec(tableCreate); err != nil {
		log.Warnf("Error on table create: %s", err.Error())
	}

	return a, nil
}

// Helper - writes Cluster object to Cloud SQL on localhost (via proxy)
func writeToCloudSQL(app *app, c Cluster) error {
	sqlInsert := `
	INSERT INTO TESTCLUSTER(c) 
		VALUES(
			$1, NOW(), 
			NOW()
		)
	`

	if _, err := app.db.Exec(sqlInsert, c); err != nil {
		return fmt.Errorf("DB.Exec: %v", err)
	}

	return nil
}

// SOURCE - https://github.com/GoogleCloudPlatform/golang-samples/blob/6c46053696035e0b5d210806f005c43da9bcb6ee/cloudsql/postgres/database-sql/cloudsql.go
// initSocketConnectionPool initializes a Unix socket connection pool for
// a Cloud SQL instance of SQL Server.
func initSocketConnectionPool() (*sql.DB, error) {
	// [START cloud_sql_postgres_databasesql_create_socket]
	var (
		dbUser                 = mustGetenv("DB_USER")                  // e.g. 'my-db-user'
		dbPwd                  = mustGetenv("DB_PASS")                  // e.g. 'my-db-password'
		instanceConnectionName = mustGetenv("INSTANCE_CONNECTION_NAME") // e.g. 'project:region:instance'
		dbName                 = mustGetenv("DB_NAME")                  // e.g. 'my-database'
	)

	socketDir, isSet := os.LookupEnv("DB_SOCKET_DIR")
	if !isSet {
		socketDir = "/cloudsql"
	}

	dbURI := fmt.Sprintf("user=%s password=%s database=%s host=%s/%s", dbUser, dbPwd, dbName, socketDir, instanceConnectionName)

	// dbPool is the pool of database connections.
	dbPool, err := sql.Open("pgx", dbURI)
	if err != nil {
		return nil, fmt.Errorf("sql.Open: %v", err)
	}

	// [START_EXCLUDE]
	configureConnectionPool(dbPool)
	// [END_EXCLUDE]

	return dbPool, nil
	// [END cloud_sql_postgres_databasesql_create_socket]
}

// initTCPConnectionPool initializes a TCP connection pool for a Cloud SQL
// instance of SQL Server.
func initTCPConnectionPool() (*sql.DB, error) {
	// [START cloud_sql_postgres_databasesql_create_tcp]
	var (
		dbUser    = mustGetenv("DB_USER") // e.g. 'my-db-user'
		dbPwd     = mustGetenv("DB_PASS") // e.g. 'my-db-password'
		dbTCPHost = mustGetenv("DB_HOST") // e.g. '127.0.0.1' ('172.17.0.1' if deployed to GAE Flex)
		dbPort    = mustGetenv("DB_PORT") // e.g. '5432'
		dbName    = mustGetenv("DB_NAME") // e.g. 'my-database'
	)

	dbURI := fmt.Sprintf("host=%s user=%s password=%s port=%s database=%s", dbTCPHost, dbUser, dbPwd, dbPort, dbName)

	// [START_EXCLUDE]
	// [START cloud_sql_postgres_databasesql_sslcerts]
	// (OPTIONAL) Configure SSL certificates
	// For deployments that connect directly to a Cloud SQL instance without
	// using the Cloud SQL Proxy, configuring SSL certificates will ensure the
	// connection is encrypted. This step is entirely OPTIONAL.
	dbRootCert := os.Getenv("DB_ROOT_CERT") // e.g., '/path/to/my/server-ca.pem'
	if dbRootCert != "" {
		var (
			dbCert = mustGetenv("DB_CERT") // e.g. '/path/to/my/client-cert.pem'
			dbKey  = mustGetenv("DB_KEY")  // e.g. '/path/to/my/client-key.pem'
		)
		dbURI += fmt.Sprintf(" sslmode=require sslrootcert=%s sslcert=%s sslkey=%s", dbRootCert, dbCert, dbKey)
	}
	// [END cloud_sql_postgres_databasesql_sslcerts]
	// [END_EXCLUDE]

	// dbPool is the pool of database connections.
	dbPool, err := sql.Open("pgx", dbURI)
	if err != nil {
		return nil, fmt.Errorf("sql.Open: %v", err)
	}

	// [START_EXCLUDE]
	configureConnectionPool(dbPool)
	// [END_EXCLUDE]

	return dbPool, nil
	// [END cloud_sql_postgres_databasesql_create_tcp]
}

// configureConnectionPool sets database connection pool properties.
// For more information, see https://golang.org/pkg/database/sql
func configureConnectionPool(dbPool *sql.DB) {
	// [START cloud_sql_postgres_databasesql_limit]

	// Set maximum number of connections in idle connection pool.
	dbPool.SetMaxIdleConns(5)

	// Set maximum number of open connections to the database.
	dbPool.SetMaxOpenConns(7)

	// [END cloud_sql_postgres_databasesql_limit]

	// [START cloud_sql_postgres_databasesql_lifetime]

	// Set Maximum time (in seconds) that a connection can remain open.
	dbPool.SetConnMaxLifetime(1800 * time.Second)

	// [END cloud_sql_postgres_databasesql_lifetime]
}

// mustGetEnv is a helper function for getting environment variables.
// Displays a warning if the environment variable is not set.
func mustGetenv(k string) string {
	v := os.Getenv(k)
	if v == "" {
		log.Fatalf("Warning: %s environment variable not set.\n", k)
	}
	return v
}
