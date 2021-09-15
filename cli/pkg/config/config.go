package config

import (
	"bufio"
	"fmt"
	"os"
	"strings"

	"github.com/spf13/viper"
)

type VpcConfig struct {
	VpcName      string `yaml:"vpcName"`
	VpcType      string `yaml:"vpcType"`
	VpcProjectID string `yaml:"vpcProjectId"`
}

type ClusterConfig struct {
	ProjectID                 string `yaml:"projectId"`
	NumNodes                  int    `yaml:"nodeSize"`
	MachineType               string `yaml:"machineType"`
	ClusterType               string `yaml:"clusterType"`
	AuthIP                    string `yaml:"authIP"`
	Region                    string `yaml:"region"`
	Zone                      string `yaml:"zone"`
	SubnetName                string `yaml:"subnetName"`
	PodCIDRName               string `yaml:"podCIDRName"`
	SvcCIDRName               string `yaml:"svcCIDRName"`
	EnableWorkloadIdentity    bool   `yaml:"enableWorkloadIdentity"`
	EnableWindowsNodepool     bool   `yaml:"enableWindowsNodepool"`
	EnablePreemptibleNodepool bool   `yaml:"enablePreemptibleNodepool"`
	DefaultNodepoolOS         string `yaml:"defaultNodepoolOS"`
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

// 1. Initialize a default Config Struct with prepopulated values,
// 2. read in the optional config.yaml and override with user-set values.
// 3. validate config values
func GetConf(cfgFile string) *Config {
	conf := InitWithDefaults()
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
			fmt.Println("Config file not found or provided - using default values")
			projectId, err := ReadProjectId()
			if err != nil {
				fmt.Println("Could not read project ID; quitting")
				os.Exit(1)
			}
			conf.ClustersProjectID = projectId
			conf.GovernanceProjectID = projectId
			conf.VpcConfig.VpcProjectID = projectId
		} else {
			// Config file was found but another error was produced
			fmt.Println(err)
			os.Exit(1)
		}
	}
	err := viper.Unmarshal(conf)
	if err != nil {
		fmt.Printf("unable to decode into config struct, %v", err)
	}
	// print(err)
	// vars := make(map[string]interface{})
	// vars["ClustersProjectName"] = conf.ClustersProjectName
	// tmpl, _ := template.ParseFiles("/tfvars.tf.tmpl")
	// file, _ := os.Create("tfvars.tf")
	// defer file.Close()
	// tmpl.Execute(file, vars)

	// The default []clusterconfig has a single cluster, but the user config could have many.
	// Set any unset default values for all the clusters.
	for i, cc := range conf.ClustersConfig {
		cc = SetClusterDefaults(cc)
		conf.ClustersConfig[i] = cc
	}

	// Validate config values
	if err := ValidateConf(conf); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

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
	// trim all whitespace
	projectId = strings.TrimSpace(projectId)
	fmt.Printf("Using project ID: %s", projectId)

	return projectId, nil
}

// Validate config before writing to tfvars
func ValidateConf(c *Config) error {
	fmt.Println("⏱ Validating Config...")
	if c.TerraformState != "local" && c.TerraformState != "cloud" {
		return fmt.Errorf("Terraform state must be one of: local, cloud")
	}
	if c.VpcConfig.VpcType != "standalone" && c.VpcConfig.VpcType != "shared" {
		return fmt.Errorf("VPC Type must be one of: standalone, shared")
	}
	if c.VpcConfig.VpcName == "" {
		return fmt.Errorf("VPC Name cannot be empty")
	}

	// Validate each ClusterConfig
	for i, cc := range c.ClustersConfig {
		if cc.ClusterType != "managed" && cc.ClusterType != "on-prem" {
			if cc.NumNodes < 1 || cc.NumNodes > 100 {
				return fmt.Errorf("ClustersConfig[%d]: NumNodes must be a number between 1-100", i)
			}
			if cc.SubnetName == "" {
				return fmt.Errorf("ClustersConfig[%d] SubnetName cannot be empty", i)
			}
			if err := validateMachineType(cc.MachineType); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
			if err := validateNodeOS(cc.DefaultNodepoolOS); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
			if err := validateRegion(cc.Region); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
			if err := validateZone(cc.Zone); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
		}
	}

	fmt.Println("✅ Config is valid. Ready to write to tfvars.")
	fmt.Printf("%+v\n", c)
	return nil
}

// TODO - use compute engine API call to get the most up to date list
func validateMachineType(machType string) error {
	// read in file: machine-types.txt
	machineTypes, err := readLines("pkg/config/machine-types.txt")
	if err != nil {
		return fmt.Errorf("Could not read machine-types.txt: %v", err)
	}
	for _, t := range machineTypes {
		if machType == t {
			return nil
		}
	}
	return fmt.Errorf("Invalid machine type")
	return nil
}

// https://cloud.google.com/kubernetes-engine/docs/concepts/node-images
func validateNodeOS(nodeOS string) error {
	validOS := []string{"cos", "cos_containerd", "ubuntu_containerd", "ubuntu", "windows_sac", "windows_sac_containerd", "windows_ltsc", "windows_ltsc_containerd"}

	for _, os := range validOS {
		if nodeOS == os {
			return nil
		}
	}
	return fmt.Errorf("NodePoolOS must be one of: %v", validOS)
}

// TODO - call the google compute engine API to get the most up to date region/zone list.
func validateRegion(region string) error {
	validRegions := []string{"asia-east1", "asia-east2", "asia-northeast1", "asia-northeast2", "asia-northeast3", "asia-south1", "asia-south2", "asia-southeast1", "asia-southeast2", "australia-southeast1", "australia-southeast2", "europe-central2", "europe-north1", "europe-west1", "europe-west2", "europe-west3", "europe-west4", "europe-west6", "northamerica-northeast1", "northamerica-northeast2", "southamerica-east1", "us-central1", "us-east1", "us-east4", "us-west1", "us-west2", "us-west3", "us-west4"}

	for _, r := range validRegions {
		if region == r {
			return nil
		}
	}
	return fmt.Errorf("Region must be one of: %v", validRegions)
}

func validateZone(zone string) error {
	validZones := []string{"us-east1-b", "us-east1-c", "us-east1-d", "us-east4-c", "us-east4-b", "us-east4-a", "us-central1-c", "us-central1-a", "us-central1-f", "us-central1-b", "us-west1-b", "us-west1-c", "us-west1-a", "europe-west4-a", "europe-west4-b", "europe-west4-c", "europe-west1-b", "europe-west1-d", "europe-west1-c", "europe-west3-c", "europe-west3-a", "europe-west3-b", "europe-west2-c", "europe-west2-b", "europe-west2-a", "asia-east1-b", "asia-east1-a", "asia-east1-c", "asia-southeast1-b", "asia-southeast1-a", "asia-southeast1-c", "asia-northeast1-b", "asia-northeast1-c", "asia-northeast1-a", "asia-south1-c", "asia-south1-b", "asia-south1-a", "australia-southeast1-b", "australia-southeast1-c", "australia-southeast1-a", "southamerica-east1-b", "southamerica-east1-c", "southamerica-east1-a", "asia-east2-a", "asia-east2-b", "asia-east2-c", "asia-northeast2-a", "asia-northeast2-b", "asia-northeast2-c", "asia-northeast3-a", "asia-northeast3-b", "asia-northeast3-c", "asia-south2-a", "asia-south2-b", "asia-south2-c", "asia-southeast2-a", "asia-southeast2-b", "asia-southeast2-c", "australia-southeast2-a", "australia-southeast2-b", "australia-southeast2-c", "europe-central2-a", "europe-central2-b", "europe-central2-c", "europe-north1-a", "europe-north1-b", "europe-north1-c", "europe-west6-a", "europe-west6-b", "europe-west6-c", "northamerica-northeast1-a", "northamerica-northeast1-b", "northamerica-northeast1-c", "northamerica-northeast2-a", "northamerica-northeast2-b", "northamerica-northeast2-c", "us-west2-a", "us-west2-b", "us-west2-c", "us-west3-a", "us-west3-b", "us-west3-c", "us-west4-a", "us-west4-b", "us-west4-c"}
	for _, z := range validZones {
		if zone == z {
			return nil
		}
	}
	return fmt.Errorf("Zone must be one of: %v", validZones)
}

// Helper function - read in text file
func readLines(path string) ([]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines, scanner.Err()
}
