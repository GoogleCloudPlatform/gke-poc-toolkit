package analytics

import (
	"bytes"
	"encoding/json"
	"gkekitctl/pkg/config"
	"net/http"
	"runtime"
	"time"

	"github.com/gofrs/uuid"
	log "github.com/sirupsen/logrus"
)

// SendMetrics runs on gkekitctl create, after config validation and before TF apply. It gets the user's OS, scrubs their project ID data, and sends their create configuration to the metrics server.
/*
NOTES
- Sending metrics is defaulted right now until the init command adds an opt-in/ configurable opt in flag
- The metrics endpoint is hardcoded right now because there's only 1 instance of the metrics server
*/

// This is an Analytics-only object representing 1 GKE cluster created with gkekitctl.
type Cluster struct {
	ClusterId                 string `json:"clusterId"`
	CreateId                  string `json:"createId"`
	Timestamp                 string `json:"timestamp"`
	OS                        string `json:"os"`
	TerraformState            string `json:"terraformState"`
	Region                    string `json:"region"`
	EnableWorkloadIdentity    bool   `json:"enableWorkloadIdentity"`
	EnablePreemptibleNodepool bool   `json:"enablePreemptibleNodepool"`
	DefaultNodepoolOS         string `json:"defaultNodepoolOS"`
	PrivateEndpoint           bool   `json:"privateEndpoint"`
	EnableConfigSync          bool   `json:"enableConfigSync"`
	EnablePolicyController    bool   `json:"enablePolicyController"`
	VPCType                   string `json:"vpcType"`
	ClusterIndex              int    `json:"clusterIndex"`
	ClusterNumNodes           int    `json:"clusterNumNodes"`
	ClusterType               string `json:"clusterType"`
	ClusterMachineType        string `json:"clusterMachineType"`
	ClusterRegion             string `json:"clusterRegion"`
	ClusterZone               string `json:"clusterZone"`
}

func SendAnalytics(conf *config.Config) {
	// Generate timestamp. Format: 2006-01-02T15:04:05.000Z
	now := time.Now()
	timestamp := now.Format("2006-01-02T15:04:05.000Z")

	// Generate CreateId used by all clusters

	// Assign UUIDs to create run and cluster
	createId, err := uuid.NewV4()
	if err != nil {
		log.Warn(err)
		return
	}

	for i, cluster := range conf.ClustersConfig {
		// Cluster Id
		clusterId, err := uuid.NewV4()
		if err != nil {
			log.Warn(err)
			return
		}

		// Create Cluster Object, omitting any user-identified data (Project IDs)
		// NOTE - ClusterId and CreateId are generated server-side before DB insert to avoid HTTP POST anti-patterns
		sendObject := Cluster{
			ClusterId:                 clusterId.String(),
			CreateId:                  createId.String(),
			Timestamp:                 timestamp,
			OS:                        runtime.GOOS,
			TerraformState:            conf.TerraformState,
			Region:                    conf.Region,
			EnableWorkloadIdentity:    conf.EnableWorkloadIdentity,
			EnablePreemptibleNodepool: conf.EnablePreemptibleNodepool,
			DefaultNodepoolOS:         conf.DefaultNodepoolOS,
			PrivateEndpoint:           conf.PrivateEndpoint,
			EnableConfigSync:          conf.ConfigSync,
			EnablePolicyController:    conf.PolicyController,
			VPCType:                   conf.VpcConfig.VpcType,
			ClusterIndex:              i,
			ClusterNumNodes:           cluster.NumNodes,
			ClusterType:               cluster.ClusterType,
			ClusterMachineType:        cluster.MachineType,
			ClusterRegion:             cluster.Region,
			ClusterZone:               cluster.Zone,
		}
		// Encode as JSON
		json, err := json.Marshal(sendObject)
		if err != nil {
			log.Warn(err)
			return
		}
		err = PostToAnalyticsServer(json)
		if err != nil {
			log.Warn(err)
			return
		}
	}
	log.Info("✅ Sent cluster info to analytics server")
	return
}

func PostToAnalyticsServer(json []byte) error {
	url := "https://analytics.gkepoctoolkit.dev"
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(json))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	return nil
}
