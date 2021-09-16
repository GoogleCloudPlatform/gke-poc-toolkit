package config

// Sets Config default values to allow for setup without a custom config.yaml file
// Default config uses a single 3-node cluster.
func InitWithDefaults() *Config {
	vpcConfig := VpcConfig{
		VpcName:     "default",
		VpcType:     "standalone",
		AuthIP:      "", //only needed for private cluster
		PodCIDRName: "podCidr",
		SvcCIDRName: "svcCidr",
	}

	clustersConfig := []ClusterConfig{
		ClusterConfig{
			NumNodes:    3,
			MachineType: "e2-standard-4",
			ClusterType: "public",
			Region:      "us-central1",
			Zone:        "us-central1-b",
			SubnetName:  "default",
		},
	}

	return &Config{
		TerraformState:            "local",
		ConfigSync:                true,
		Prefix:                    "love",
		VpcConfig:                 vpcConfig,
		ClustersConfig:            clustersConfig,
		EnableWorkloadIdentity:    true,
		EnableWindowsNodepool:     false,
		EnablePreemptibleNodepool: false,
		DefaultNodepoolOS:         "cos_containerd",
	}
}

// For a single CLuster Config, make sure any required fields are set before validation
func SetClusterDefaults(cc ClusterConfig) ClusterConfig {
	if cc.NumNodes == 0 {
		cc.NumNodes = 3
	}
	if cc.MachineType == "" {
		cc.MachineType = "e2-standard-4"
	}
	if cc.ClusterType == "" {
		cc.ClusterType = "public"
	}
	if cc.Region == "" {
		cc.Region = "us-central1"
	}
	if cc.Zone == "" {
		cc.Zone = "us-central1-b"
	}
	if cc.SubnetName == "" {
		cc.SubnetName = "default"
	}
	return cc
}
