package config

import (
	"bufio"
	"fmt"
	"net"
	"os"
	"strings"

	"github.com/spf13/viper"

	"context"

	compute "cloud.google.com/go/compute/apiv1"
	"google.golang.org/api/iterator"
	computepb "google.golang.org/genproto/googleapis/cloud/compute/v1"
)

// Config defines the config file structure. Has config-wide vars, and two sub-structs:
// a VPC Config, and a slice of Cluster Configs, representing one or more GKE clusters.
type Config struct {
	Region                    string          `yaml:"region"`
	TerraformState            string          `yaml:"terraformState"`
	ClustersProjectID         string          `yaml:"clustersProjectId"`
	GovernanceProjectID       string          `yaml:"governanceProjectId"`
	ConfigSync                bool            `yaml:"configSync"`
	PrivateEndpoint           bool            `yaml:"privateEndpoint"`
	EnableWorkloadIdentity    bool            `yaml:"enableWorkloadIdentity"`
	EnableWindowsNodepool     bool            `yaml:"enableWindowsNodepool"`
	EnablePreemptibleNodepool bool            `yaml:"enablePreemptibleNodepool"`
	DefaultNodepoolOS         string          `yaml:"defaultNodepoolOS"`
	VpcConfig                 VpcConfig       `yaml:"vpcConfig"`
	ClustersConfig            []ClusterConfig `yaml:"clustersConfig"`
}

type VpcConfig struct {
	VpcName      string `yaml:"vpcName"`
	VpcType      string `yaml:"vpcType"`
	VpcProjectID string `yaml:"vpcProjectId"`
	PodCIDRName  string `yaml:"podCIDRName"`
	SvcCIDRName  string `yaml:"svcCIDRName"`
	AuthIP       string `yaml:"authIP"`
}

type ClusterConfig struct {
	ClusterName string `yaml:"clusterName"`
	ProjectID   string `yaml:"projectId"`
	NumNodes    int    `yaml:"nodeSize"`
	MachineType string `yaml:"machineType"`
	ClusterType string `yaml:"clusterType"`
	AuthIP      string `yaml:"authIP"`
	Region      string `yaml:"region"`
	Zone        string `yaml:"zone"`
	SubnetName  string `yaml:"subnetName"`
}

// Create a new config instance.
var conf *Config

// InitConf is the top-level config init function, run on `gkekitctl create`.
// Reads in + validates config before writing to tfvars.
func InitConf(cfgFile string) *Config {
	conf := &Config{}
	var err error
	// if cfgFile is *not* set, prompts the user for a project ID, + reads / validates the default config
	if cfgFile == "" {
		conf, err = InitWithDefaults()
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
	} else {
		// if cfgFile is set, reads in + validates the user's config.
		conf, err = readConf(cfgFile)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
	}
	// Validate config
	err = ValidateConf(conf)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	return conf
}

// helper function - reads in config.yml file as struct
func readConf(cfgFile string) (*Config, error) {
	conf := &Config{}
	viper.SetConfigFile(cfgFile)
	err := viper.ReadInConfig()
	if err != nil {
		return conf, err
	}
	err = viper.Unmarshal(conf)
	if err != nil {
		return conf, err
	}
	return conf, nil
}

// ReadProjectId runs when a user runs `gkekitctl create` without providing a config.yaml file.
// This will prompt them for their GCP project id, which will be used in the default config.
func ReadProjectId() (string, error) {
	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Enter your Google Cloud Project ID: ")
	projectId, err := reader.ReadString('\n')
	if err != nil {
		return "", err
	}
	// trim all whitespace
	projectId = strings.TrimSpace(projectId)
	fmt.Printf("Using project ID: %s \n", projectId)

	return projectId, nil
}

// This function runs when a user runs `gkekitctl create` without providing a config.yaml file.
// This function: 1) reads in the default config file, and 2) inserts the user's GCP Project ID into the config.
func InitWithDefaults() (*Config, error) {
	// Read default config
	config, err := readConf("samples/default-config.yaml")
	if err != nil {
		return config, err
	}

	// Prompt for project ID
	projectId, err := ReadProjectId()
	if err != nil {
		return config, err
	}

	// populate default conf with user's project ID
	config.GovernanceProjectID = projectId
	config.ClustersProjectID = projectId
	config.VpcConfig.VpcProjectID = projectId

	for i := range config.ClustersConfig {
		config.ClustersConfig[i].ProjectID = projectId
	}

	return config, nil
}

// Validate config before writing to tfvars
func ValidateConf(c *Config) error {
	fmt.Println("⏱ Validating Config...")

	// Config-wide vars
	if c.TerraformState != "local" && c.TerraformState != "cloud" {
		return fmt.Errorf("Terraform state must be one of: local, cloud")
	}
	if err := validateNodeOS(c.DefaultNodepoolOS); err != nil {
		return err
	}
	if err := validateConfigRegion(c.GovernanceProjectID, c.Region); err != nil {
		return err
	}

	// VPC Config vars
	if c.VpcConfig.VpcType != "standalone" && c.VpcConfig.VpcType != "shared" {
		return fmt.Errorf("VPC Type must be one of: standalone, shared")
	}
	if c.VpcConfig.VpcName == "" {
		return fmt.Errorf("VPC Name cannot be empty")
	}
	if err := validateAuthIP(c.VpcConfig.AuthIP); err != nil {
		return err
	}

	// Validate each ClusterConfig
	for i, cc := range c.ClustersConfig {
		// TODO - what is cluster type? why is line 125 here?
		if cc.ClusterType != "managed" && cc.ClusterType != "on-prem" {
			if cc.NumNodes < 1 || cc.NumNodes > 100 {
				return fmt.Errorf("ClustersConfig[%d]: NumNodes must be a number between 1-100", i)
			}
			if cc.SubnetName == "" {
				return fmt.Errorf("ClustersConfig[%d] SubnetName cannot be empty", i)
			}
			if err := validateRegionAndZone(c.ClustersProjectID, cc.Region, cc.Zone); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
			if err := validateMachineType(c.ClustersProjectID, cc.MachineType, cc.Zone); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
			if err := validateNodeOS(c.DefaultNodepoolOS); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
		}
	}

	fmt.Println("✅ Config is valid. Ready to write to tfvars.")
	return nil
}

// verifies that field is a valid IP address
func validateAuthIP(authIp string) error {
	if net.ParseIP(authIp) == nil {
		return fmt.Errorf("Auth IP Address: %s is an invalid IP\n", authIp)
	}
	// fmt.Printf("🔎 Auth IP Address: %s - Valid\n", authIp)
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

// Validate config-wide region
// TODO - currently this client lib func is returning an empty list of regions, rather than a list of GCP regions. need to investigate why, possible client lib bug.
func validateConfigRegion(projectID, region string) error {
	return nil
	// ctx := context.Background()
	// c, err := compute.NewRegionsRESTClient(ctx)
	// if err != nil {
	// 	return err
	// }
	// defer c.Close()

	// req := &computepb.ListRegionsRequest{
	// 	Project: projectID,
	// }
	// it := c.List(ctx, req)
	// // Populate map of regions + zones for this project
	// regions := []string{}
	// for {
	// 	resp, err := it.Next()
	// 	if err == iterator.Done {
	// 		break
	// 	}
	// 	if err != nil {
	// 		return err
	// 	}
	// 	r := resp.GetName()
	// 	spl := strings.Split(r, "/")
	// 	if len(spl) < 2 {
	// 		return fmt.Errorf("Error validating config region (%s) - GCP region (%s) is invalid\n", region, r)
	// 	}
	// 	sanitizedRegion := spl[len(spl)-1]
	// 	regions = append(regions, sanitizedRegion)
	// 	if sanitizedRegion == region {
	// 		fmt.Printf("🌍Config-wide region %s is valid.\n", region)
	// 		return nil
	// 	}
	// }
	// return fmt.Errorf("Config-wide region %s not found. Must be one of: %v\n", region, regions)
}

// Validate region + zone for specific clusters.
func validateRegionAndZone(projectId string, clusterRegion string, clusterZone string) error {
	regions := map[string]bool{} // region --> true
	zones := map[string]string{} // zone --> region

	ctx := context.Background()
	c, err := compute.NewZonesRESTClient(ctx)
	if err != nil {
		return err
	}
	defer c.Close()

	req := &computepb.ListZonesRequest{
		Project: projectId,
	}
	it := c.List(ctx, req)
	var sanitizedRegion string

	// Populate map of regions + zones for this project
	for {
		resp, err := it.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return err
		}
		r := *resp.Region

		spl := strings.Split(r, "/")
		if len(spl) < 2 {
			fmt.Printf("Zone %s does not have a valid region - %s\n", *resp.Name, *resp.Region)
		}
		// Format region from https://www.googleapis.com/compute/v1/projects/megan-2021/regions/us-central1  --> us-central1
		sanitizedRegion = spl[len(spl)-1]
		regions[sanitizedRegion] = true
		zones[*resp.Name] = sanitizedRegion
		_ = resp
	}

	// Region must exist
	if _, ok := regions[clusterRegion]; !ok {
		return fmt.Errorf("Region %s invalid - must be one of: %v", clusterRegion, regions)
	}

	// Zone must exist
	if _, ok := zones[clusterZone]; !ok {
		return fmt.Errorf("Zone %s invalid - must be one of: %v", clusterZone, zones)
	}

	// Zone must be in the right region
	if zoneRegion, _ := zones[clusterZone]; zoneRegion != clusterRegion {
		return fmt.Errorf("Zone %s must be in region %s, not region %s", clusterZone, zoneRegion, clusterRegion)
	}

	// fmt.Println("✅ Region and zone valid.")
	return nil
}

func validateMachineType(projectId string, machineType string, zone string) error {
	ctx := context.Background()
	c, err := compute.NewMachineTypesRESTClient(ctx)
	if err != nil {
		return err
	}
	defer c.Close()

	req := &computepb.ListMachineTypesRequest{
		Project: projectId,
		Zone:    zone,
	}
	it := c.List(ctx, req)
	validMachineTypes := []string{}
	for {
		resp, err := it.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return err
		}
		if *resp.Name == machineType {
			// fmt.Printf("✅ Machine type %s is valid\n", machineType)
			return nil
		}
		validMachineTypes = append(validMachineTypes, *resp.Name)
		_ = resp
	}

	return fmt.Errorf("Machine type %s is invalid, must be one of: %v", machineType, validMachineTypes)
}
