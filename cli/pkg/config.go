package config

import (
	"fmt"

	"github.com/spf13/viper"
)

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
	err := viper.ReadInConfig()

	if err != nil {
		fmt.Printf("%v", err)
	}

	conf := &Config{}
	err = viper.Unmarshal(conf)
	if err != nil {
		fmt.Printf("unable to decode into config struct, %v", err)
	}

	return conf
}
