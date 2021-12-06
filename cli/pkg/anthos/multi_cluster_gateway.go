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

package anthos

import (
	"fmt"
	"io/ioutil"

	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/tools/clientcmd/api"
)

func InitMCG(kubeConfig *api.Config) error {
	mcgConfigs, err := ioutil.ReadFile("templates/gateway_api_crds.yaml")
	if err != nil {
		return fmt.Errorf("failed to read in gateway api crd yaml: %w", err)
	}
	for clusterName := range kubeConfig.Clusters {
		cfg, err := clientcmd.NewNonInteractiveClientConfig(*kubeConfig, clusterName, &clientcmd.ConfigOverrides{CurrentContext: clusterName}, nil).ClientConfig()
		if err != nil {
			return fmt.Errorf("failed to create Kubernetes configuration cluster=%s: %w", clusterName, err)
		}

		if err := Apply(cfg, clusterName, mcgConfigs); err != nil {
			return fmt.Errorf("failed to apply gateway api crd to cluster=%s: %w", clusterName, err)
		}
	}
	return nil
}
