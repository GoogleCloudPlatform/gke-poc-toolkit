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
	"gkekitctl/pkg/lifecycle"

	log "github.com/sirupsen/logrus"

	"github.com/spf13/cobra"
)

// connectCmd represents the connect command
var connectCmd = &cobra.Command{
	Use:     "connect",
	Short:   "connect for all clusters in GKE Demo Environment",
	Example: ` gkekitctl connect -p <fleet-project-id>`,

	Run: func(cmd *cobra.Command, args []string) {
		log.Println("Getting credentials...")
		// conf := config.InitConf(cfgFile)

		log.Info("☸️ Generating Kubeconfig...")
		kc, err := lifecycle.GenerateKubeConfig(fleetProjectId)
		if err != nil {
			log.Errorf("🚨 Failed to generate kube config: %s", err)
		} else {
			log.Infof("✅ Kubeconfig generated: %+v", kc)
		}
	},
}

func init() {
	rootCmd.AddCommand(connectCmd)
}
