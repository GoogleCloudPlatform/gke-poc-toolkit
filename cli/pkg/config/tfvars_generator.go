package config

import (
	"bytes"
	"io/ioutil"
	"os"
	"text/template"

	log "github.com/sirupsen/logrus"
)

func GenerateTfvars(conf *Config) {
	vars := make(map[string]interface{})

	// Set base config vars
	vars["Region"] = conf.Region
	//tfstate is handled in go deploy not terraform
	// vars["TerraformState"] = conf.TerraformState
	vars["ClustersProjectId"] = conf.ClustersProjectID
	vars["GovernanceProjectId"] = conf.GovernanceProjectID
	vars["ConfigSync"] = conf.ConfigSync
	if conf.PrivateEndpoint == true {
		vars["PrivateEndpoint"] = false
	} else {
		vars["PrivateEndpoint"] = true
	}
	vars["DefaultNodepoolOS"] = conf.DefaultNodepoolOS
	vars["EnableWorkloadIdentity"] = conf.EnableWorkloadIdentity
	vars["EnableWindowsNodepool"] = conf.EnableWindowsNodepool
	vars["EnablePreemptibleNodepool"] = conf.EnablePreemptibleNodepool

	// Set vpc config vars
	if conf.VpcConfig.VpcType == "standalone" {
		vars["VpcType"] = false
	} else {
		vars["VpcType"] = true
	}
	vars["VpcName"] = conf.VpcConfig.VpcName
	vars["VpcProjectId"] = conf.VpcConfig.VpcProjectID
	vars["PodCidrName"] = conf.VpcConfig.PodCIDRName
	vars["SvcCidrName"] = conf.VpcConfig.SvcCIDRName
	vars["AuthIp"] = conf.VpcConfig.AuthIP
	println(conf.VpcConfig.AuthIP)

	// First phase of templating tfvars (base and VPC configs)
	tmpl, err := template.ParseFiles("templates/terraform.tfvars.tmpl")
	if err != nil {
		log.Fatalf("error parsing tfvars template: %s", err)
	}
	file, err := os.Create("terraform.tfvars")
	if err != nil {
		log.Fatalf("error creating tfvars file: %s", err)
	}
	defer file.Close()
	err = tmpl.Execute(file, vars)
	if err != nil {
		log.Fatalf("error executing tffavs template merge: %s", err)
	}

	// Set Cluster config vars
	for cc := range conf.ClustersConfig {
		clusterVars := make(map[string]interface{})
		clusterVars["ClusterName"] = conf.ClustersConfig[cc].ClusterName
		clusterVars["Region"] = conf.ClustersConfig[cc].Region
		clusterVars["SubnetName"] = conf.ClustersConfig[cc].SubnetName
		tmpl, err := template.ParseFiles("templates/cluster_config.tmpl")
		if err != nil {
			log.Fatalf("error parsing cluster_config template: %s", err)
		}
		file, err := os.Create("clusters.tf")
		if err != nil {
			log.Fatalf("error creating clusters tf file: %s", err)
		}
		defer file.Close()
		err = tmpl.Execute(file, clusterVars)
		if err != nil {
			log.Fatalf("error executing clusters template merge: %s", err)
		}
		files := []string{"terraform.tfvars", "clusters.tf"}
		var buf bytes.Buffer
		for _, file := range files {
			b, err := ioutil.ReadFile(file)
			if err != nil {
				log.Fatalf("error reading %s: %s", file, err)
			}
			buf.Write(b)
			err = ioutil.WriteFile("terraform.tfvars", buf.Bytes(), 0644)
			if err != nil {
				log.Fatalf("error writing to %s: %s", file, err)
			}
		}
	}
	err = os.Remove("clusters.tf")
	if err != nil {
		log.Fatalf("error deleting clusters.tf file: %s", err)
	}
	f, err := os.OpenFile("terraform.tfvars",
		os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Fatalf("error opening tfvars file for final insert: %s", err)
	}
	defer f.Close()
	if _, err := f.WriteString("}\n"); err != nil {
		log.Fatalf("error appending } to the tfvars file: %s", err)
	}
}

// // todo - come back to the hclwrite code if we can solve for dynamically stamping out cluster configs
// f := hclwrite.NewEmptyFile()
// tfFile, err := os.Create("terraform.tfvars")
// if err != nil {
// 	log.Error(err)
// 	return
// }
// rootBody := f.Body()
// // Set config vars
// rootBody.SetAttributeValue("project_id", cty.StringVal(conf.ClustersProjectID))
// rootBody.SetAttributeValue("governance_project_id", cty.StringVal(conf.GovernanceProjectID))
// rootBody.SetAttributeValue("prefix", cty.StringVal(conf.Prefix))
// rootBody.SetAttributeValue("region", cty.StringVal(conf.Region))
// rootBody.SetAttributeValue("private_endpoint", cty.BoolVal(conf.PrivateEndpoint))
// // rootBody.SetAttributeValue("config_sync", cty.BoolVal(conf.ConfigSync))

// // Set VPC config vars
// if conf.VpcConfig.VpcType == "standalone" {
// 	rootBody.SetAttributeValue("shared_vpc", cty.BoolVal(false))
// } else {
// 	rootBody.SetAttributeValue("shared_vpc", cty.BoolVal(true))
// }
// rootBody.SetAttributeValue("shared_vpc_name", cty.StringVal(conf.VpcConfig.VpcName))
// rootBody.SetAttributeValue("shared_vpc_project_id", cty.StringVal(conf.VpcConfig.VpcProjectID))
// rootBody.SetAttributeValue("shared_vpc_ip_range_pods_name", cty.StringVal(conf.VpcConfig.PodCIDRName))
// rootBody.SetAttributeValue("shared_vpc_ip_range_services_name", cty.StringVal(conf.VpcConfig.SvcCIDRName))

// for i, cc := range conf.ClustersConfig {
// 	rootBody.AppendNewline()
// 	cluster_name := cc.ClusterName
// 	rootBody.SetAttributeValue(
// 		"cluster_config", cty.ObjectVal(map[string]cty.Value{
// 			cluster_name: cty.ObjectVal(map[string]cty.Value{
// 				"region":      cty.StringVal(conf.ClustersConfig[i].Region),
// 				"subnet_name": cty.StringVal(conf.ClustersConfig[i].SubnetName),
// 			}),
// 		}),
// 	)
// }
// tfFile.Write(f.Bytes())
