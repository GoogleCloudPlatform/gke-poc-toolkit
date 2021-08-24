package config

import (
	"github.com/spf13/viper"
)

// Sets Config default values to allow for setup without a custom config.yaml file
// Default config uses a single 3-node cluster.
func InitWithDefaults(projectId string) {
	viper.SetDefault("TerraformState", "local")
	viper.SetDefault("ConfigSync", true)
	viper.SetDefault("ClustersProjectID", projectId)
	viper.SetDefault("Prefix", "")
	viper.SetDefault("GovernanceProjectID", projectId)

	vpcConfig := &VpcConfig{
		VpcName:      "default",
		VpcType:      "standalone",
		VpcProjectID: projectId,
	}
	viper.SetDefault("VpcConfig", vpcConfig)

	clustersConfig := []ClusterConfig{
		ClusterConfig{
			ProjectID:                 projectId,
			NumNodes:                  3,
			MachineType:               "e2-standard-4",
			ClusterType:               "public",
			AuthIP:                    "", //only needed for private cluster
			Region:                    "us-central1",
			Zone:                      "us-central1-b",
			SubnetName:                "default",
			PodCIDRName:               "",
			SvcCIDRName:               "",
			EnableWorkloadIdentity:    true,
			EnableWindowsNodepool:     false,
			EnablePreemptibleNodepool: false,
			DefaultNodepoolOS:         "COS",
		},
	}
	viper.SetDefault("ClustersConfig", clustersConfig)
}
