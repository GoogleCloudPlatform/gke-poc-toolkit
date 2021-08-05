package config


// Create private data struct to hold config options.
type Config struct {
	TerraformState        string      `yaml:"terraformState"`
	ConfigSync            interface{} `yaml:"configSync"`
	ClustersProjectName   interface{} `yaml:"clustersProjectName"`
	Prefix                interface{} `yaml:"prefix"`
	GovernanceProjectName interface{} `yaml:"governanceProjectName"`
	VpcConfig             struct {
		Type           string      `yaml:"type"`
		SubnetName     interface{} `yaml:"subnetName"`
		PodCIDRName    interface{} `yaml:"podCIDRName"`
		SvcCIDRName    interface{} `yaml:"svcCIDRName"`
		VpcProjectName interface{} `yaml:"vpcProjectName"`
	} `yaml:"vpcConfig"`
	ClustersConfig []struct {
		ProjectName interface{} `yaml:"projectName"`
		NodeSize    interface{} `yaml:"nodeSize"`
		ClusterType string      `yaml:"clusterType"`
		AuthIP      interface{} `yaml:"authIP"`
		Region      interface{} `yaml:"region"`
		Zone        interface{} `yaml:"zone"`
		NodePools   []struct {
			Os string `yaml:"os"`
		} `yaml:"nodePools"`
	} `yaml:"clustersConfig"`
}