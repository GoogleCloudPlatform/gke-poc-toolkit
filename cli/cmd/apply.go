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
	gkekitctl apply --config <file.yaml>`,
	Run: func(cmd *cobra.Command, args []string) {
		bucketNameClusters, err := cmd.Flags().GetString("gkestate")
		if err != nil {
			log.Errorf("🚨Failed to get bucketNameClusters value from flag: %s", err)
		}
		if bucketNameClusters != "" {
			log.Infof("✅ Terraform state storage bucket for clusters is %s", bucketNameClusters)
		}
		bucketNameSharedVPC, err := cmd.Flags().GetString("vpcstate")
		if err != nil {
			log.Errorf("🚨Failed to get bucketNameSharedVPC value from flag: %s", err)
		}
		if bucketNameSharedVPC != "" {
			log.Infof("✅ Terraform state storage bucket for shared VPC is %s", bucketNameSharedVPC)
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
		err = config.CheckTfStateType(conf, bucketNameClusters, bucketNameSharedVPC)

		if err != nil {
			log.Errorf("🚨 Failed checking TF state type: %s", err)
		} else {
			log.Info("✅ TF state configured successfully.")
		}

		if conf.VpcConfig.VpcType == "shared" {
			lifecycle.InitTF("shared_vpc")
			lifecycle.ApplyTF("shared_vpc")
		}
		lifecycle.InitTF("cluster_build")
		lifecycle.ApplyTF("cluster_build")

		// Authenticate Kubernetes client-go to all clusters
		log.Info("☸️ Generating Kubeconfig...")
		kc, err := lifecycle.GenerateKubeConfig(conf)
		if err != nil {
			log.Errorf("🚨 Failed to generate kube config: %s", err)
		} else {
			log.Infof("✅ Kubeconfig generated: %+v", kc)
		}

		// Verify access to Kubernetes API on all clusters
		log.Info("☸️  Verifying Kubernetes API access for all clusters...")
		err = lifecycle.ListNamespaces(kc)
		if err != nil {
			log.Errorf("🚨 Failed API access check on clusters: %s", err)
		} else {
			log.Info("✅ Clusters API access check passed.")
		}
	},
}

func init() {
	var bucketNameClusters string
	var bucketNameSharedVPC string

	rootCmd.AddCommand(applyCmd)
	applyCmd.Flags().StringVarP(&bucketNameClusters, "gkestate", "g", "", "GKE Tf State bucket name")
	applyCmd.Flags().StringVarP(&bucketNameSharedVPC, "vpcstate", "v", "", "Shared VPC Tf State bucket name")
}
