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
	vars["PolicyController"] = conf.PolicyController
	vars["PrivateEndpoint"] = conf.PrivateEndpoint
	vars["ReleaseChannel"] = conf.ReleaseChannel
	vars["InitialNodeCount"] = conf.InitialNodeCount
	vars["MinNodeCount"] = conf.MinNodeCount
	vars["MaxNodeCount"] = conf.MaxNodeCount
	vars["DefaultNodepoolOS"] = conf.DefaultNodepoolOS
	vars["EnableWindowsNodepool"] = conf.EnableWindowsNodepool
	vars["EnablePreemptibleNodepool"] = conf.EnablePreemptibleNodepool
	vars["MultiClusterGateway"] = conf.MultiClusterGateway
	vars["AnthosServiceMesh"] = conf.AnthosServiceMesh
	vars["TFModuleRepo"] = conf.TFModuleRepo
	vars["TFModuleBranch"] = conf.TFModuleBranch

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
	vars["AuthCIDR"] = conf.VpcConfig.AuthCIDR

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
		clusterVars["MachineType"] = conf.ClustersConfig[cc].MachineType
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
	log.Info("✅ TFVars generated successfully.")

}
