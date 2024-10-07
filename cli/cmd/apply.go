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
package cmd

import (
	"gkekitctl/pkg/analytics"
	"gkekitctl/pkg/config"
	"gkekitctl/pkg/lifecycle"

	log "github.com/sirupsen/logrus"

	"github.com/spf13/cobra"
)

// createCmd represents the create command
var applyCmd = &cobra.Command{
	Use:   "apply",
	Short: "Create or Update GKE Demo Environment",
	Example: ` gkekitctl apply
	gkekitctl apply --config <file.yaml>
	gkekitctl apply --config <file.yaml> -g <cluster-tfstate-clusters> -v <cluster-tfstate-network> -f <cluster-tfstate-fleet>`,
	Run: func(cmd *cobra.Command, args []string) {
		bucketNameNetwork, err := cmd.Flags().GetString("vpcstate")
		if err != nil {
			log.Errorf("🚨Failed to get bucketNameSharedVPC value from flag: %s", err)
		}
		if bucketNameNetwork != "" {
			log.Infof("✅ Terraform state storage bucket for shared VPC is %s", bucketNameNetwork)
		}
		bucketNameFleet, err := cmd.Flags().GetString("fleetstate")
		if err != nil {
			log.Errorf("🚨Failed to get bucketNameFleet value from flag: %s", err)
		}
		if bucketNameFleet != "" {
			log.Infof("✅ Terraform state storage bucket for Fleet is %s", bucketNameFleet)
		}
		bucketNameClusters, err := cmd.Flags().GetString("gkestate")
		if err != nil {
			log.Errorf("🚨Failed to get bucketNameClusters value from flag: %s", err)
		}
		if bucketNameClusters != "" {
			log.Infof("✅ Terraform state storage bucket for clusters is %s", bucketNameClusters)
		}

		log.Info("👟 Started config validation...")
		conf := config.InitConf(cfgFile)

		// Send user analytics - async
		if conf.SendAnalytics {
			go analytics.SendAnalytics(conf, Version, GitCommit)
		}

		log.Info("👟 Started generating TFVars...")
		config.GenerateTfvars(conf)

		log.Info("👟 Started configuring TF State...")
		err = config.CheckTfStateType(conf, bucketNameNetwork, bucketNameFleet, bucketNameClusters)

		if err != nil {
			log.Errorf("🚨 Failed setting up TF state: %s", err)
		} else {
			log.Info("✅ TF state configured successfully.")
		}

		lifecycle.InitTF("network")
		lifecycle.ApplyTF("network")
		lifecycle.InitTF("fleet")
		lifecycle.ApplyTF("fleet")
		lifecycle.InitTF("clusters")
		lifecycle.ApplyTF("clusters")

		// Authenticate Kubernetes client-go to all clusters
		log.Info("☸️ Generating Kubeconfig...")
		kc, err := lifecycle.GenerateKubeConfig(conf.FleetProjectID)
		if err != nil {
			log.Errorf("🚨 Failed to generate kube config: %s", err)
		} else {
			log.Infof("✅ Kubeconfig generated: %+v", kc)
		}
	},
}

func init() {
	var bucketNameClusters string
	var bucketNameNetwork string
	var bucketNameFleet string

	rootCmd.AddCommand(applyCmd)
	applyCmd.Flags().StringVarP(&bucketNameClusters, "gkestate", "g", "", "GKE Tf State bucket name")
	applyCmd.Flags().StringVarP(&bucketNameNetwork, "vpcstate", "v", "", "Network Tf State bucket name")
	applyCmd.Flags().StringVarP(&bucketNameFleet, "fleetstate", "f", "", "Fleet Tf State bucket name")
}
