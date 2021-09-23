package config

import (
	"bufio"
	"fmt"
	"os"
	"strings"

	"github.com/spf13/viper"

	"context"

	compute "cloud.google.com/go/compute/apiv1"
	"google.golang.org/api/iterator"
	computepb "google.golang.org/genproto/googleapis/cloud/compute/v1"
)

type VpcConfig struct {
	VpcName      string `yaml:"vpcName"`
	VpcType      string `yaml:"vpcType"`
	VpcProjectID string `yaml:"vpcProjectId"`
	PodCIDRName  string `yaml:"podCIDRName"`
	SvcCIDRName  string `yaml:"svcCIDRName"`
	AuthIP       string `yaml:"authIP"`
}

type ClusterConfig struct {
	ClusterName               string `yaml:"clusterName"`
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
	Prefix                    string          `yaml:"prefix"`
	Region                    string          `yaml:"region"`
	TerraformState            string          `yaml:"terraformState"`
	ClustersProjectID         string          `yaml:"clustersProjectId"`
	GovernanceProjectID       string          `yaml:"governanceProjectId"`
	ConfigSync                bool            `yaml:"configSync"`
	PrivateEndpoint           bool            `yaml:"privateEndpoint"`
	DefaultNodepoolOS         string          `yaml:"defaultNodepoolOS"`
	EnableWorkloadIdentity    bool            `yaml:"enableWorkloadIdentity"`
	EnableWindowsNodepool     bool            `yaml:"enableWindowsNodepool"`
	EnablePreemptibleNodepool bool            `yaml:"enablePreemptibleNodepool"`
	VpcConfig                 VpcConfig       `yaml:"vpcConfig"`
	ClustersConfig            []ClusterConfig `yaml:"clustersConfig"`
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
			if err := validateRegionAndZone(cc.ProjectID, cc.Region, cc.Zone); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
			if err := validateMachineType(cc.ProjectID, cc.MachineType, cc.Zone); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
			if err := validateNodeOS(cc.DefaultNodepoolOS); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
		}
	}

	fmt.Println("✅ Config is valid. Ready to write to tfvars.")
	fmt.Printf("%+v\n", c)
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

func validateRegionAndZone(projectId string, region string, zone string) error {
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
	if _, ok := regions[region]; !ok {
		return fmt.Errorf("Region %s invalid - must be one of: %v", region, regions)
	}

	// Zone must exist
	if _, ok := zones[zone]; !ok {
		return fmt.Errorf("Zone %s invalid - must be one of: %v", zone, zones)
	}

	// Zone must be in the right region
	if zoneRegion, _ := zones[zone]; zoneRegion != region {
		return fmt.Errorf("Zone %s must be in region %s, not region %s", zone, zoneRegion, region)
	}

	fmt.Println("✅ Region and zone valid.")
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
			fmt.Printf("✅ Machine type %s is valid\n", machineType)
			return nil
		}
		validMachineTypes = append(validMachineTypes, *resp.Name)
		_ = resp
	}

	return fmt.Errorf("Machine type %s is invalid, must be one of: %v", machineType, validMachineTypes)
}
