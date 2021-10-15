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
	"log"

	"github.com/spf13/cobra"
)

// deleteCmd represents the delete command
var deleteCmd = &cobra.Command{
	Use:     "delete",
	Short:   "delete GKE Demo Environment",
	Example: ` gkekitctl delete`,

	Run: func(cmd *cobra.Command, args []string) {
		log.Println("Starting delete...")
		conf := config.InitConf(cfgFile)
		if conf.VpcConfig.VpcType == "shared" {
			lifecycle.DestroyTF("../terraform/cluster_build")
			lifecycle.DestroyTF("../terraform/shared_vpc")
		} else {
			lifecycle.DestroyTF("../terraform/cluster_build")
		}
	},
}

func init() {
	rootCmd.AddCommand(deleteCmd)
}
