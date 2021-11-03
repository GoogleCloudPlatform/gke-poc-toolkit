/*
Copyright © 2021 Google Inc.

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

package scripts

import (
	"fmt"
	"gkekitctl/pkg/config"
	"os"
	"os/exec"

	log "github.com/sirupsen/logrus"
)

// Runs before Terraform
func ExecutePreScripts(conf *config.Config) {
	// log.Println("👾 Running pre-create scripts...")
	// if conf.ConfigSync {
	// 	err := executeScriptHelper("pkg/scripts/config_sync_ssh.sh", map[string]string{})
	// 	if err != nil {
	// 		log.Errorf("⚠️ SSH setup failed with error: %v", err)
	// 	}
	// }
}

// Runs after Terraform
func ExecutePostScripts(conf *config.Config) {
	// log.Println("👾 Running post-create scripts...")
	// if conf.ConfigSync {
	// 	// If user has Config Sync enabled, then bootstrap their Cloud Source sync repo.
	// 	// (This only needs to happen once, since all clusters sync to the same repo.)
	// 	envVars := map[string]string{"PROJECT_ID": conf.ClustersProjectID}
	// 	err := executeScriptHelper("pkg/scripts/bootstrap_config_sync_repo.sh", envVars)
	// 	if err != nil {
	// 		log.Errorf("⚠️ Bootstrap Config Sync Repo failed with error: %v", err)
	// 	}
	// 	// Every cluster needs the config sync gitcreds secret
	// 	for _, cluster := range conf.ClustersConfig {
	// 		envVars := map[string]string{"PROJECT_ID": conf.ClustersProjectID, "CLUSTER_NAME": cluster.ClusterName, "CLUSTER_REGION": cluster.Region, "CLUSTER_ZONE": cluster.Zone}

	// 		dir, _ := os.Getwd()
	// 		log.Infof("Current working dir is: %s", dir)
	// 		log.Infof("About to execute gitcreds... env is: %+v", envVars)
	// 		err := executeScriptHelper("pkg/scripts/config_sync_gitcreds.sh", envVars)
	// 		if err != nil {
	// 			log.Errorf("⚠️ Git creds failed with err: %v", err)
	// 		}
	// 	}
	// }
	// If user has Config Connector enabled, complete post-install steps *for every cluster.*
	// if conf.ConfigConnector {
	// 	for _, cluster := range conf.ClustersConfig {
	// 		envVars := map[string]string{"PROJECT_ID": conf.ClustersProjectID, "CLUSTER_NAME": cluster.ClusterName, "CLUSTER_REGION": cluster.Region, "CLUSTER_ZONE": cluster.Zone}
	// 		err := executeScriptHelper("pkg/scripts/config_connector_post_install.sh", envVars)
	// 		if err != nil {
	// 			log.Errorf("⚠️ Config Connector post-install failed with error: %v", err)
	// 		}
	// 	}
	// }
}

func executeScriptHelper(pathToScript string, envVars map[string]string) error {
	cmd := exec.Command("/bin/sh", pathToScript)
	cmd.Env = os.Environ()
	// append custom env vars to the environment
	for k, v := range envVars {
		cmd.Env = append(cmd.Env, fmt.Sprintf("%s=%s", k, v))
	}
	// exec the script
	stdout, err := cmd.Output()
	log.Info(string(stdout))

	if err != nil {
		return err
	}
	return nil
}
