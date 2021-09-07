package config

// Sets Config default values to allow for setup without a custom config.yaml file
// Default config uses a single 3-node cluster.
func InitWithDefaults() *Config {
	vpcConfig := VpcConfig{
		VpcName: "default",
		VpcType: "standalone",
	}

	clustersConfig := []ClusterConfig{
		ClusterConfig{
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

	return &Config{
		TerraformState: "local",
		ConfigSync:     true,
		Prefix:         "",
		VpcConfig:      vpcConfig,
		ClustersConfig: clustersConfig,
	}
}
