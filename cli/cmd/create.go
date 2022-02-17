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
	"gkekitctl/pkg/anthos"
	"gkekitctl/pkg/config"
	"gkekitctl/pkg/lifecycle"

	log "github.com/sirupsen/logrus"

	"github.com/spf13/cobra"
)

// createCmd represents the create command
var createCmd = &cobra.Command{
	Use:   "create",
	Short: "Create GKE Demo Environment",
	Example: ` gkekitctl create
	gkekitctl create --config <file.yaml>`,
	Run: func(cmd *cobra.Command, args []string) {
		log.Info("👟 Started config validation...")
		conf := config.InitConf(cfgFile)
		log.Info("👟 Started generating TFVars...")

		// Send user analytics - async
		if conf.SendAnalytics {
			go analytics.SendAnalytics(conf, Version, GitCommit)
		}

		config.GenerateTfvars(conf)
		log.Info("👟 Started configuring TF State...")
		tfStateBucket, err := config.CheckTfStateType(conf)
		if err != nil {
			log.Errorf("🚨 Failed checking TF state type: %s", err)
		} else {
			log.Info("✅ TF state configured successfully.")
		}

		if conf.VpcConfig.VpcType == "shared" {
			lifecycle.InitTF("shared_vpc", tfStateBucket[1])
			lifecycle.ApplyTF("shared_vpc")
		}
		lifecycle.InitTF("cluster_build", tfStateBucket[0])
		lifecycle.ApplyTF("cluster_build")

		// Authenticate Kubernetes client-go to all clusters
		log.Info("☸️ Generating Kubeconfig...")
		kc, err := anthos.GenerateKubeConfig(conf)
		if err != nil {
			log.Errorf("🚨 Failed to generate kube config: %s", err)
		} else {
			log.Infof("✅ Kubeconfig generated: %+v", kc)
		}

		// Verify access to Kubernetes API on all clusters
		log.Info("☸️  Verifying Kubernetes API access for all clusters...")
		err = anthos.ListNamespaces(kc)
		if err != nil {
			log.Errorf("🚨 Failed API access check on clusters: %s", err)
		} else {
			log.Info("✅ Clusters API access check passed.")
		}

		// Init Multi-cluster Gateway
		// if conf.MultiClusterGateway {
		// 	err := anthos.InitMCG(kc)
		// 	if err != nil {
		// 		log.Errorf("🚨 Failed to initialize Multi-cluster Gateway CRDs: %s", err)
		// 	} else {
		// 		log.Info("✅ MultiCluster Gateway CRDs installed successfully.")
		// 	}
		// }

		// Run Anthos modules if anthos features are enabled
		// if conf.ConfigSync || conf.MultiClusterGateway {
		// 	lifecycle.InitTF("anthos", tfStateBucket[2])
		// 	lifecycle.ApplyTF("anthos")
		// }

		// Init ACM (either ConfigSync or ConfigSync plus PolicyController)
		if conf.ConfigSync {
			err := anthos.InitACM(conf, kc)
			if err != nil {
				log.Errorf("🚨 Failed to initialize ACM: %s", err)
			} else {
				log.Info("✅ ConfigSync setup successfully.")
			}
		}
		if err == nil {
			log.Info("✅ Clusters API access check passed.")
		}
	},
}

func init() {
	rootCmd.AddCommand(createCmd)
}
