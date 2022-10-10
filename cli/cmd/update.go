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
	"gkekitctl/pkg/config"
	"gkekitctl/pkg/lifecycle"

	log "github.com/sirupsen/logrus"

	"github.com/spf13/cobra"
)

// createCmd represents the create command
var updateCmd = &cobra.Command{
	Use:     "update",
	Short:   "update your gke toolkit environment",
	Example: `gkekitctl update --config <file.yaml>`,
	Run: func(cmd *cobra.Command, args []string) {
		log.Info("👟 Started config validation...")
		conf := config.InitConf(cfgFile)
		log.Info("👟 Started generating TFVars...")

		config.GenerateTfvars(conf)

		if conf.VpcConfig.VpcType == "shared" {
			lifecycle.InitTF("shared_vpc")
			lifecycle.ApplyTF("shared_vpc")
		}
		lifecycle.InitTF("cluster_build")
		lifecycle.ApplyTF("cluster_build")
	},
}

func init() {
	rootCmd.AddCommand(updateCmd)
}
