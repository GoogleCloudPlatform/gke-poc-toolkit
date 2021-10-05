/*
Copyright © 2021 NAME HERE <EMAIL ADDRESS>

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

	"github.com/spf13/cobra"
)

// createCmd represents the create command
var createSharedVpcCmd = &cobra.Command{
	Use:   "sharedvpc",
	Short: "Create shared VPC",
	Example: ` gkekitctl create sharedvpc
	gkekitctl --config <file.yaml>`,
	Run: func(cmd *cobra.Command, args []string) {
		conf := config.InitConf(cfgFile)
		config.GenerateTfvars(conf)
		tfDir := "../terraform/shared_vpc"
		lifecycle.InitTF(tfDir)
		lifecycle.ApplyTF(tfDir)
	},
}

func init() {
	createCmd.AddCommand(createSharedVpcCmd)
}
