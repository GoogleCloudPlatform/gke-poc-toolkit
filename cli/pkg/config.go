package config

import (
	"fmt"

	"github.com/spf13/viper"
)

// Create private data struct to hold config options.
type Config struct {
	TerraformState      string      `yaml:"terraformState"`
	ConfigSync          bool        `yaml:"configSync"`
	ClustersProjectID   string      `yaml:"clustersProjectId"`
	Prefix              interface{} `yaml:"prefix"`
	GovernanceProjectID interface{} `yaml:"governanceProjectId"`
	VpcConfig           struct {
		VpcName      interface{} `yaml:"vpcName"`
		VpcType      string      `yaml:"vpcType"`
		VpcProjectID interface{} `yaml:"vpcProjectId"`
	} `yaml:"vpcConfig"`
	ClustersConfig []struct {
		ProjectID                 interface{} `yaml:"projectId"`
		NodeSize                  interface{} `yaml:"nodeSize"`
		ClusterType               string      `yaml:"clusterType"`
		AuthIP                    interface{} `yaml:"authIP"`
		Region                    string      `yaml:"region"`
		Zone                      string      `yaml:"zone"`
		SubnetName                interface{} `yaml:"subnetName"`
		PodCIDRName               interface{} `yaml:"podCIDRName"`
		SvcCIDRName               interface{} `yaml:"svcCIDRName"`
		EnableWindowsNodepool     bool        `yaml:"enableWindowsNodepool"`
		EnablePreemptibleNodepool bool        `yaml:"enablePreemptibleNodepool"`
		DefaultNodepoolOS         string      `yaml:"defaultNodepoolOS"`
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
	// print(err)
	// vars := make(map[string]interface{})
	// vars["ClustersProjectName"] = conf.ClustersProjectName
	// tmpl, _ := template.ParseFiles("/tfvars.tf.tmpl")
	// file, _ := os.Create("tfvars.tf")
	// defer file.Close()
	// tmpl.Execute(file, vars)

	return conf
}
