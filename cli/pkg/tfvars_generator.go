package config

import (
	"os"
	"text/template"
)

func GenerateTfvars(conf *Config) {
	vars := make(map[string]interface{})
	vars["ClustersProjectName"] = conf.ClustersProjectName
	vars["GovernanceProjectName"] = conf.GovernanceProjectName
	vars["Region"] = conf.ClustersConfig[0].Region
	// fmt.Printf("%v", vars)
	vars["ClusterType"] = conf.ClustersConfig[0].ClusterType
	vars["Zone"] = conf.ClustersConfig[0].Zone
	vars["AuthIP"] = conf.ClustersConfig[0].AuthIP
	tmpl, _ := template.ParseFiles("templates/tfvars.tf.tmpl")
	file, _ := os.Create("tfvars.tf")
	defer file.Close()
	tmpl.Execute(file, vars)

}
