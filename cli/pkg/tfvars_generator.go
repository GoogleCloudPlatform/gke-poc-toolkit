package config

import (
	"os"
	"text/template"
)

func GenerateTfvars(conf *Config) {
	vars := make(map[string]interface{})
	vars["ClustersProjectName"] = conf.ClustersProjectID
	vars["GovernanceProjectName"] = conf.GovernanceProjectID
	vars["Region"] = conf.ClustersConfig[0].Region
	vars["ClusterType"] = conf.ClustersConfig[0].ClusterType
	vars["Zone"] = conf.ClustersConfig[0].Zone
	vars["AuthIP"] = conf.ClustersConfig[0].AuthIP
	vars["EnableWindowsNodepool"] = conf.ClustersConfig[0].EnableWindowsNodepool
	vars["EnablePreemptibleNodepool"] = conf.ClustersConfig[0].EnablePreemptibleNodepool
	vars["VpcType"] = conf.VpcConfig.VpcType
	vars["VpcName"] = conf.VpcConfig.VpcName
	vars["SubnetName"] = conf.ClustersConfig[0].SubnetName
	vars["VpcProjectId"] = conf.VpcConfig.VpcProjectID
	vars["PodCidrName"] = conf.ClustersConfig[0].PodCIDRName
	vars["SvcCidrName"] = conf.ClustersConfig[0].SvcCIDRName

	tmpl, _ := template.ParseFiles("templates/tfvars.tf.tmpl")
	file, _ := os.Create("tfvars.tf")
	defer file.Close()
	tmpl.Execute(file, vars)

}