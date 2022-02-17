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
	"context"
	"fmt"
	"io/ioutil"
	"strings"

	"gkekitctl/pkg/config"

	log "github.com/sirupsen/logrus"
	v1 "k8s.io/api/core/v1"
	"k8s.io/client-go/kubernetes"
	_ "k8s.io/client-go/plugin/pkg/client/auth/gcp" // register GCP auth provider
	"k8s.io/client-go/tools/clientcmd/api"

	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"os"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/tools/clientcmd"

	"golang.org/x/crypto/ssh"
)

// If ConfigSync is enabled, this function runs after TF apply and does the following:
// 1. Generates ssh keypair
// 2. Prompts user to register ssh public key to their Cloud Source Repositories
// 3. (if private endpoints) Prompts user to run make start proxy in another tab
// 4. Authenticates to each GKE cluster (using proxy if needed) and creates gitcreds secret
//		from private key. (This is needed for Config Sync to read from Cloud Source Repos)
// 5. Prints the gcloud clone cmd for user to clone their ConfigSync repo to push stuff to it. (DONE.)
func InitACM(conf *config.Config, kc *api.Config) error {
	log.Info("🔄 Finishing ACM install...")
	// Authenticate Kubernetes client-go to all clusters
	log.Info("☸️ Generating Kubeconfig...")
	kc, err := GenerateKubeConfig(conf)
	if err != nil {
		return err
	}
	log.Infof("✔️ Kubeconfig generated: %+v", kc)

	// Verify access to Kubernetes API on all clusters
	log.Info("☸️  Verifying Kubernetes API access for all clusters...")
	err = ListNamespaces(kc)
	if err != nil {
		return err
	}
	return nil
}

// ssh-keygen
// Source: https://stackoverflow.com/questions/21151714/go-generate-an-ssh-public-key
func InitSSH() error {
	privateKeyPath := "id_rsa"
	pubKeyPath := "id_rsa.pub"

	// make ssh dir if not exists
	err := os.MkdirAll("ssh", 0700)
	if err != nil {
		log.Warnf("Error making ssh dir: %v", err)
	}

	// ssh keygen to local dir
	log.Info("Generating private key")
	privateKey, err := rsa.GenerateKey(rand.Reader, 4096)
	if err != nil {
		return err
	}

	// generate and write private key as PEM
	log.Info("Encoding private key")
	privateKeyFile, err := os.Create(privateKeyPath)
	defer privateKeyFile.Close()
	if err != nil {
		return err
	}
	privateKeyPEM := &pem.Block{Type: "RSA PRIVATE KEY", Bytes: x509.MarshalPKCS1PrivateKey(privateKey)}
	if err := pem.Encode(privateKeyFile, privateKeyPEM); err != nil {
		return err
	}

	// generate and write public key
	log.Info("Generating public key")
	pub, err := ssh.NewPublicKey(&privateKey.PublicKey)
	if err != nil {
		return err
	}
	return ioutil.WriteFile(pubKeyPath, ssh.MarshalAuthorizedKey(pub), 0655)
}

func PromptUser(conf *config.Config) error {
	// read public key as string
	bytes, err := ioutil.ReadFile("id_rsa.pub")
	if err != nil {
		return err
	}
	pubKey := string(bytes)

	// Prompt user to register ssh public key to their Cloud Source Repositories
	log.Info("💻 Copy the key below to the clipboard, then open this link to register: https://source.cloud.google.com/user/ssh_keys")
	log.Info(pubKey)
	log.Info("Once you've registered the key, press enter to continue...")
	fmt.Scanln() // wait for Enter Key

	// Prompt user to run make start proxy
	if conf.PrivateEndpoint {
		log.Info("⚠️ Your clusters have Private Endpoints. Please open another terminal tab and run the following command to proxy via your GCE Bastion Host.")
		log.Infof("gcloud beta compute ssh gke-tk-bastion --tunnel-through-iap --project %s --zone %s-b -- -4 -L8888:127.0.0.1:8888", conf.ClustersProjectID, conf.ClustersConfig[0].Region)
		log.Info("Once the proxy tunnel is running, press enter to continue...")
		fmt.Scanln() // wait for Enter Key
	}
	return nil
}

// Create gitcreds Secret in every cluster, using the contents of the id_rsa file as data.
func CreateGitCredsSecret(kubeConfig *api.Config) error {
	ctx := context.Background()

	// Get string value of private key
	privateKey, err := ioutil.ReadFile("id_rsa")
	if err != nil {
		return fmt.Errorf("Failed to read id_rsa from file: %v", err)
	}
	privateKeyString := string(privateKey)
	// log.Infof("Private key string is the contents below:")
	// log.Info(privateKeyString)

	for clusterName := range kubeConfig.Clusters {
		cfg, err := clientcmd.NewNonInteractiveClientConfig(*kubeConfig, clusterName, &clientcmd.ConfigOverrides{CurrentContext: clusterName}, nil).ClientConfig()
		if err != nil {
			return fmt.Errorf("failed to create Kubernetes configuration cluster=%s: %w", clusterName, err)
		}

		k8s, err := kubernetes.NewForConfig(cfg)
		if err != nil {
			return fmt.Errorf("failed to create Kubernetes client cluster=%s: %w", clusterName, err)
		}

		err = WaitForNamespace(k8s, ctx, "config-management-system", clusterName)
		if err != nil {
			return fmt.Errorf("config management system namespace is not ready on cluster=%s: %w", clusterName, err)
		}

		_, err = k8s.CoreV1().Secrets("config-management-system").Create(ctx, &v1.Secret{
			ObjectMeta: metav1.ObjectMeta{
				Name: "git-creds",
			},
			StringData: map[string]string{"ssh": privateKeyString},
		}, metav1.CreateOptions{})

		if err != nil {
			if strings.Contains(err.Error(), "already exists") {
				log.Warn("git-creds secret already exists")
			} else {
				return fmt.Errorf("failed to create gitcreds secret- cluster=%s: %w", clusterName, err)
			}
		}
	}
	return nil
}
