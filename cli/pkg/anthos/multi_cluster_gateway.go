package anthos

import (
	"fmt"
	"gkekitctl/pkg/config"
	"io/ioutil"

	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/tools/clientcmd/api"
)

func InitMCG(conf *config.Config, kubeConfig *api.Config) error {
	mcgConfigs, err := ioutil.ReadFile("templates/gateway_api_crd.yaml")
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
