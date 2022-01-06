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
	"gkekitctl/pkg/cli_init"

	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

// createCmd represents the create command
var initCmd = &cobra.Command{
	Use:     "init",
	Short:   "Initialize local environment for the cli",
	Example: ` gkekitctl init`,
	Run: func(cmd *cobra.Command, args []string) {
		folders := []string{"samples", "templates", "cluster_build", "shared_vpc"}
		err := cli_init.InitFlatFiles(folders)
		if err != nil {
			log.Errorf("🚨 Failed to initialize gkekitctl: %v", err)
		}
		// Run opt-in analytics prompt
		err = cli_init.OptInAnalytics()
		if err != nil {
			log.Warnf("Failed to initialize user analytics: %v", err)
		}
		log.Info("🎉 GKE PoC Toolkit has been initialized! You're ready to run gkekitctl create.")
	},
}

func init() {
	rootCmd.AddCommand(initCmd)
}
