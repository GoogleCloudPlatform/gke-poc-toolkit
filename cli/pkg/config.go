package config

import (
	"bufio"
	"fmt"
	"os"

	"github.com/spf13/viper"
)

// Enum for cluster type 
type ClusterType string 
const (
	"public" ClusterType = iota
	"private"
)

type VpcConfig struct {
	VpcName      string `yaml:"vpcName"`
	VpcType      string `yaml:"vpcType"`
	VpcProjectID string `yaml:"vpcProjectId"`
}

type ClusterConfig struct {
	ProjectID                  string `yaml:"projectId"`
	NumNodes                   int    `yaml:"nodeSize"`
	MachineType                string `yaml:"machineType"`
	ClusterType                string `yaml:"clusterType"`
	AuthIP                     string `yaml:"authIP"`
	Region                     string `yaml:"region"`
	Zone                       string `yaml:"zone"`
	SubnetName                 string `yaml:"subnetName"`
	PodCIDRName                string `yaml:"podCIDRName"`
	SvcCIDRName                string `yaml:"svcCIDRName"`
	EnableWorkloadIdentitybool bool   `yaml:"enableWorkloadIdentity"`
	EnableWindowsNodepool      bool   `yaml:"enableWindowsNodepool"`
	EnablePreemptibleNodepool  bool   `yaml:"enablePreemptibleNodepool"`
	DefaultNodepoolOS          string `yaml:"defaultNodepoolOS"`
}

// Create private data struct to hold config options.
type Config struct {
	TerraformState      string          `yaml:"terraformState"`
	ConfigSync          bool            `yaml:"configSync"`
	ClustersProjectID   string          `yaml:"clustersProjectId"`
	Prefix              string          `yaml:"prefix"`
	GovernanceProjectID string          `yaml:"governanceProjectId"`
	VpcConfig           VpcConfig       `yaml:"vpcConfig"`
	ClustersConfig      []ClusterConfig `yaml:"clustersConfig"`
}

// Create a new config instance.
var conf *Config

// Read the config file from the current directory and marshal
// into the conf config struct.
func GetConf(cfgFile string) *Config {
	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		// home, err := os.UserHomeDir()
		// cobra.CheckErr(err)

		// Search config in home directory with name ".gkekitctl" (without extension).
		viper.AddConfigPath(".")
		viper.SetConfigType("yaml")
		viper.SetConfigName(".gkekitctl")
	}
	if err := viper.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); ok {
			// Config file not found; ignore error if desired
			fmt.Println("Config file not found - using default values")
			projectId, err := ReadProjectId()
			if err != nil {
				fmt.Println("Could not read project ID; quitting")
				os.Exit(1)
			}
			InitWithDefaults(projectId)
		} else {
			// Config file was found but another error was produced
			fmt.Println(err)
			os.Exit(1)
		}
	}

	conf := &Config{}
	err := viper.Unmarshal(conf)
	if err != nil {
		fmt.Printf("unable to decode into config struct, %v", err)
	}
	fmt.Printf("%+v\n", conf)
	// print(err)
	// vars := make(map[string]interface{})
	// vars["ClustersProjectName"] = conf.ClustersProjectName
	// tmpl, _ := template.ParseFiles("/tfvars.tf.tmpl")
	// file, _ := os.Create("tfvars.tf")
	// defer file.Close()
	// tmpl.Execute(file, vars)

	return conf
}

// reads project ID from user input - used when default values are used over config.yaml
func ReadProjectId() (string, error) {
	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Enter your Google Cloud Project ID: ")
	projectId, err := reader.ReadString('\n')
	if err != nil {
		return "", err
	}
	fmt.Printf("Using project ID: %s", projectId)

	return projectId, nil
}
