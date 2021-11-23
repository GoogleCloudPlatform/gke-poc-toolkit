package anthos

import (
	"gkekitctl/pkg/config"

	log "github.com/sirupsen/logrus"
)

func InitMCG(conf *config.Config) error {
	log.Info("🔄 Finishing MCG install...")

	// Authenticate Kubernetes client-go to all clusters
	log.Info("☸️ Generating Kubeconfig...")
	kc, err := GenerateKubeConfig(conf)
	if err != nil {
		return err
	}
	log.Infof("✅ Kubeconfig generated: %+v", kc)
}
