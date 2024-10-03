/*
Copyright © 2020 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package config

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strings"

	log "github.com/sirupsen/logrus"

	"github.com/spf13/viper"

	"context"

	compute "cloud.google.com/go/compute/apiv1"
	serviceusage "cloud.google.com/go/serviceusage/apiv1"
	"google.golang.org/api/iterator"
	serviceusagepb "google.golang.org/genproto/googleapis/api/serviceusage/v1"
	computepb "google.golang.org/genproto/googleapis/cloud/compute/v1"
)

// Config defines the config file structure. Has config-wide vars, and two sub-structs:
// a VPC Config, and a slice of Cluster Configs, representing one or more GKE clusters.
type Config struct {
	RegionalClusters           bool            `yaml:"regionalClusters"`
	AuthenticatorSecurityGroup string          `yaml:"authenticatorSecurityGroup"`
	TerraformState             string          `yaml:"terraformState"`
	SendAnalytics              bool            `yaml:"sendAnalytics"`
	ClustersProjectID          string          `yaml:"clustersProjectId"`
	FleetProjectID             string          `yaml:"fleetProjectId"`
	PrivateEndpoint            bool            `yaml:"privateEndpoint"`
	ReleaseChannel             string          `yaml:"releaseChannel"`
	InitialNodeCount           int             `yaml:"initialNodeCount"`
	MinNodeCount               int             `yaml:"minNodeCount`
	MaxNodeCount               int             `yaml:"maxNodeCount`
	DefaultNodepoolOS          string          `yaml:"defaultNodepoolOS"`
	TFModuleRepo               string          `yaml:"tfModuleRepo"`
	TFModuleBranch             string          `yaml:"tfModuleBranch"`
	ConfigSyncRepo             string          `yaml:"configSyncRepo"`
	ConfigSyncRepoBranch       string          `yaml:"configSyncRepoBranch"`
	ConfigSyncRepoDir          string          `yaml:"configSyncRepoDir"`
	VpcConfig                  VpcConfig       `yaml:"vpcConfig"`
	ClustersConfig             []ClusterConfig `yaml:"clustersConfig"`
}

type VpcConfig struct {
	VpcName        string `yaml:"vpcName"`
	VpcType        string `yaml:"vpcType"`
	VpcProjectID   string `yaml:"vpcProjectId"`
	VpcPodCIDRName string `yaml:"vpcPodCIDRName"`
	VpcSvcCIDRName string `yaml:"vpcSvcCIDRName"`
}

type ClusterConfig struct {
	ClusterName string   `yaml:"clusterName"`
	MachineType string   `yaml:"machineType"`
	ClusterType string   `yaml:"clusterType"`
	Region      string   `yaml:"region"`
	Zones       []string `yaml:"[zone]"`
	SubnetName  string   `yaml:"subnetName"`
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
			log.Error(err)
			os.Exit(1)
		}
	} else {
		// if cfgFile is set, reads in + validates the user's config.
		conf, err = readConf(cfgFile)
		if err != nil {
			log.Error(err)
			os.Exit(1)
		}
	}
	// Enable GCP APIs - Temporarily adding all apis needed to deal with flakes in the enable service TF module
	serviceIds := []string{
		"iam.googleapis.com",
		"storage.googleapis.com",
		"compute.googleapis.com",
		"logging.googleapis.com",
		"monitoring.googleapis.com",
		"containerregistry.googleapis.com",
		"container.googleapis.com",
		"binaryauthorization.googleapis.com",
		"stackdriver.googleapis.com",
		"iap.googleapis.com",
		"cloudresourcemanager.googleapis.com",
		"dns.googleapis.com",
		"iamcredentials.googleapis.com",
		"stackdriver.googleapis.com",
		"cloudkms.googleapis.com",
	}
	enableService(conf.ClustersProjectID, serviceIds)
	anthosServiceIds := []string{
		"anthos.googleapis.com",
		"gkehub.googleapis.com",
		"sourcerepo.googleapis.com",
		"anthosconfigmanagement.googleapis.com",
		"anthos.googleapis.com",
		"gkehub.googleapis.com",
		"multiclusterservicediscovery.googleapis.com",
		"multiclusteringress.googleapis.com",
		"trafficdirector.googleapis.com",
		"mesh.googleapis.com",
		"multiclustermetering.googleapis.com",
	}
	enableService(conf.ClustersProjectID, anthosServiceIds)

	// Validate config
	err = ValidateConf(conf)
	if err != nil {
		log.Error(err)
		os.Exit(1)
	}

	// Set Tf Module Repo and Branch
	err = setTfModuleRepo(conf.TFModuleRepo, conf.TFModuleBranch)
	if err != nil {
		log.Error(err)
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
	log.Print("Enter your Google Cloud Project ID: ")
	projectId, err := reader.ReadString('\n')
	if err != nil {
		return "", err
	}
	// trim all whitespace
	projectId = strings.TrimSpace(projectId)
	log.Printf("Using project ID: %s \n", projectId)

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
	config.ClustersProjectID = projectId
	config.VpcConfig.VpcProjectID = projectId

	return config, nil
}

// Validate config before writing to tfvars
func ValidateConf(c *Config) error {
	log.Println("⏱ Validating Config...")

	// Config-wide vars
	if c.TerraformState != "local" && c.TerraformState != "cloud" {
		return fmt.Errorf("terraform state must be one of: local, cloud")
	}
	// if err := validateNodeOS(c.DefaultNodepoolOS); err != nil {
	// 	return err
	// }
	if err := validateTFModuleRepo(c.TFModuleRepo); err != nil {
		return err
	}
	if c.MinNodeCount < 1 || c.MaxNodeCount > 100 {
		return fmt.Errorf("NumNodes must be a number between 1-100")
	}

	// VPC Config vars
	if c.VpcConfig.VpcType != "standalone" && c.VpcConfig.VpcType != "shared" {
		return fmt.Errorf("VPC Type must be one of: standalone, shared")
	}
	if c.VpcConfig.VpcName == "" {
		return fmt.Errorf("VPC Name cannot be empty")
	}
	// err := validateVPC(c.VpcConfig.VpcName, c.VpcConfig.VpcProjectID)
	// if err != nil {
	// 	return err
	// }
	// log.Printf("🌐 VPC name %s is valid + does not yet exist in VPC project %s\n", c.VpcConfig.VpcName, c.VpcConfig.VpcProjectID)

	// Validate each ClusterConfig
	for i, cc := range c.ClustersConfig {
		// TODO - what is cluster type? why is line 125 here?
		if cc.ClusterType != "managed" && cc.ClusterType != "on-prem" {
			if cc.SubnetName == "" {
				return fmt.Errorf("ClustersConfig[%d] SubnetName cannot be empty", i)
			}
			if err := validateRegionAndZone(c.ClustersProjectID, cc.Region, cc.Zones); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
			if err := validateMachineType(c.ClustersProjectID, cc.MachineType, cc.Zones); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
			if err := validateNodeOS(c.DefaultNodepoolOS); err != nil {
				return fmt.Errorf("ClustersConfig[%d]: %s", i, err)
			}
		}
	}

	log.Println("✅ Config is valid.")
	return nil
}

// verifies that field is a valid CIDR of format x.x.x.x/xx
// func validateAuthCIDR(authCIDR string) error {
// 	ip, ipNet, err := net.ParseCIDR(authCIDR)
// 	if err != nil {
// 		return fmt.Errorf("Auth CIDR %s is invalid: %v", authCIDR, err)
// 	}
// 	log.Infof("🌐 Valid CIDR: IP: %s, IPNet: %s", ip, ipNet)
// 	return nil
// }

// https://cloud.google.com/kubernetes-engine/docs/concepts/node-images
func validateNodeOS(nodeOS string) error {
	validOS := []string{"cos", "cos_containerd", "ubuntu_containerd", "ubuntu"}

	for _, os := range validOS {
		if nodeOS == os {
			return nil
		}
	}
	return fmt.Errorf("NodePoolOS must be one of: %v", validOS)
}

// Validate config-wide region
// NOTE - the ListRegionsRequest client lib function is returning an empty list for any GCP
// project. ListZones works fine. So for now, using ListZones result (where each zone has a region)
// to bootstrap a list of valid regions.
// func validateConfigRegion(projectID, region string) error {
// 	ctx := context.Background()
// 	c, err := compute.NewZonesRESTClient(ctx)
// 	if err != nil {
// 		return err
// 	}
// 	defer c.Close()

// 	req := &computepb.ListZonesRequest{
// 		Project: projectID,
// 	}
// 	it := c.List(ctx, req)
// 	// Use zones to populate a map of valid regions for this project
// 	regions := map[string]bool{}
// 	for {
// 		resp, err := it.Next()
// 		if err == iterator.Done {
// 			break
// 		}
// 		if err != nil {
// 			return err
// 		}
// 		r := resp.GetRegion()
// 		spl := strings.Split(r, "/")
// 		if len(spl) < 2 {
// 			return fmt.Errorf("error validating region (%s) - GCP region (%s) is invalid\n", region, r)
// 		}
// 		sanitizedRegion := spl[len(spl)-1]
// 		regions[sanitizedRegion] = true
// 	}

// 	// check if Config.Region is in the map.
// 	if _, ok := regions[region]; !ok {
// 		return fmt.Errorf("config-wide region %s not found. Must be one of: %v\n", region, regions)
// 	}
// 	return nil
// }

// Validate region + zone for specific clusters.
func validateRegionAndZone(projectId string, clusterRegion string, clusterZones []string) error {
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
			log.Warnf("Zone %s does not have a valid region - %s\n", *resp.Name, *resp.Region)
		}
		// Format region from https://www.googleapis.com/compute/v1/projects/megan-2021/regions/us-central1  --> us-central1
		sanitizedRegion = spl[len(spl)-1]
		regions[sanitizedRegion] = true
		zones[*resp.Name] = sanitizedRegion
		_ = resp
	}

	// Region must exist
	if _, ok := regions[clusterRegion]; !ok {
		return fmt.Errorf("region %s invalid - must be one of: %v", clusterRegion, regions)
	}

	// Zone must exist
	for _, clusterZone := range clusterZones {
		if _, ok := zones[clusterZone]; !ok {
			return fmt.Errorf("zone %s invalid - must be one of: %v", clusterZone, zones)
		}
	}

	// Zone must be in the right region
	for _, clusterZone := range clusterZones {
		if zoneRegion, _ := zones[clusterZone]; zoneRegion != clusterRegion {
			return fmt.Errorf("zone %s must be in region %s, not region %s", clusterZone, zoneRegion, clusterRegion)
		}
	}
	return nil
}

func validateMachineType(projectId string, machineType string, zones []string) error {
	for _, zone := range zones {
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
				return nil
			}
			validMachineTypes = append(validMachineTypes, *resp.Name)
			_ = resp
		}
		return fmt.Errorf("machine type %s is invalid, must be one of: %v", machineType, validMachineTypes)
	}
	return nil
}

func validateTFModuleRepo(repoPath string) error {
	validRepo := []string{"../terraform/modules/", "github.com/GoogleCloudPlatform/gke-poc-toolkit//terraform/modules/"}

	for _, repo := range validRepo {
		if repoPath == repo {
			return nil
		} else if strings.Contains(repoPath, "gke-poc-toolkit//terraform/modules/") {
			return nil
		} else {
			log.Fatalf("Terraform module repo must be: %v, or a fork: github.com/<FORK>/gke-poc-toolkit//terraform/modules/", validRepo)
		}
	}
	return nil
}

// if shared VPC, checks if VPC name already exists in the VPC project
// https://cloud.google.com/go/docs/reference/cloud.google.com/go/latest/compute/apiv1#cloud_google_com_go_compute_apiv1_NetworksClient_Get
// https://pkg.go.dev/google.golang.org/genproto/googleapis/cloud/compute/v1#GetNetworkRequest.
func validateVPC(vpcName string, vpcProject string) error {
	ctx := context.Background()
	c, err := compute.NewNetworksRESTClient(ctx)
	if err != nil {
		return err
	}
	defer c.Close()

	req := &computepb.GetNetworkRequest{
		Network: vpcName,
		Project: vpcProject,
	}
	_, err = c.Get(ctx, req)
	// 404 = Good
	if err != nil && strings.Contains(err.Error(), "not found") {
		log.Infof("VPC %s was not found in project %s", vpcName, vpcProject)
		return nil
	}
	return fmt.Errorf("VPC %s already exists in project %s", vpcName, vpcProject)
}

func enableService(projectId string, serviceIds []string) {
	ctx := context.Background()
	c, err := serviceusage.NewClient(ctx)
	if err != nil {
		log.Fatalf("error initiating service usage client: %s", err)
	}
	defer c.Close()

	project := "projects/" + projectId
	log.Printf("Enabling GCP APIs: %s", serviceIds)
	req := &serviceusagepb.BatchEnableServicesRequest{
		Parent:     project,
		ServiceIds: serviceIds,
	}
	op, err := c.BatchEnableServices(ctx, req)
	if err != nil {
		log.Fatalf("error with batch enable service request: %s", err)
	}

	resp, err := op.Wait(ctx)
	if err != nil {
		log.Fatalf("error enabling gcp service: %s", err)
	}
	// TODO: Use resp.
	_ = resp
}

func setTfModuleRepo(tfRepo string, tfBranch string) error {
	files := []string{"clusters/main.tf", "network/main.tf", "fleet/main.tf"}
	for _, file := range files {
		err := replaceWord("{{.TFModuleRepo}}", file, tfRepo)
		if err != nil {
			log.Fatalf("error updating TFModuleRepo: %s", err)
		}
		err = replaceWord("{{.TFModuleBranch}}", file, tfBranch)
		if err != nil {
			log.Fatalf("error updating TFModuleBranch: %s", err)
		}
	}
	log.Println("✅ main.tf files created. Ready to write to tfvars.")
	return nil
}

func replaceWord(word string, file string, tfRepo string) error {
	input, err := os.ReadFile(file)
	if err != nil {
		log.Fatalf("error reading file: %s", err)
	}
	output := bytes.Replace(input, []byte(word), []byte(tfRepo), -1)
	if err = os.WriteFile(file, output, 0666); err != nil {
		log.Fatalf("error writing file: %s", err)
	}
	return nil
}
