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

package postcreate

import (
	"fmt"
	"gkekitctl/pkg/config"
	"os"
	"os/exec"

	log "github.com/sirupsen/logrus"
)

func ExecuteScripts(conf *config.Config) {
	log.Println("👾 Running post-create scripts...")
	// If user has Config Sync enabled, then bootstrap their Cloud Source sync repo.
	// (This only needs to happen once, since all clusters sync to the same repo.)
	if conf.ConfigSync {
		envVars := map[string]string{"PROJECT_ID": conf.ClustersProjectID}
		err := executeScriptHelper("pkg/postcreate/bootstrap_config_sync_repo.sh", envVars)
		if err != nil {
			log.Errorf("⚠️ Bootstrap Config Sync Repo failed with error: %v", err)
		}
	}

	// If user has Config Connector enabled, complete post-install steps *for every cluster.*
	// if conf.ConfigConnector {
	// 	for _, cluster := range conf.ClustersConfig {
	// 		envVars := map[string]string{"PROJECT_ID": conf.ClustersProjectID, "CLUSTER_NAME": cluster.ClusterName, "CLUSTER_REGION": cluster.Region, "CLUSTER_ZONE": cluster.Zone}
	// 		err := executeScriptHelper("pkg/postcreate/config_connector_post_install.sh", envVars)
	// 		if err != nil {
	// 			log.Errorf("⚠️ Config Connector post-install failed with error: %v", err)
	// 		}
	// 	}
	// }
	log.Info("✅ Post-create scripts complete!")
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

	if err != nil {
		return err
	}

	log.Println(string(stdout))
	return nil
}
