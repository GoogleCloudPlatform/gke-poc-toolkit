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
	"encoding/base64"
	"fmt"
	"gkekitctl/pkg/config"

	"github.com/pytimer/k8sutil/apply"
	log "github.com/sirupsen/logrus"
	"google.golang.org/api/container/v1"
	clientgo "k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/discovery"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/kubernetes"
	_ "k8s.io/client-go/plugin/pkg/client/auth/gcp"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/tools/clientcmd/api"
)

func GenerateKubeConfig(conf *config.Config) (*api.Config, error) {
	projectId := conf.ClustersProjectID
	log.Infof("Clusters Project ID is %s", projectId)
	ctx := context.Background()

	svc, err := container.NewService(ctx)
	if err != nil {
		return api.NewConfig(), fmt.Errorf("container.NewService: %w", err)
	}

	// Basic config structure
	ret := api.Config{
		APIVersion: "v1",
		Kind:       "Config",
		Clusters:   map[string]*api.Cluster{},  // Clusters is a map of referencable names to cluster configs
		AuthInfos:  map[string]*api.AuthInfo{}, // AuthInfos is a map of referencable names to user configs
		Contexts:   map[string]*api.Context{},  // Contexts is a map of referencable names to context configs
	}

	// Ask Google for a list of all kube clusters in the given project.
	resp, err := svc.Projects.Zones.Clusters.List(projectId, "-").Context(ctx).Do()
	if err != nil {
		return &ret, fmt.Errorf("clusters list project=%s: %w", projectId, err)
	}

	for _, f := range resp.Clusters {
		name := fmt.Sprintf("gke_%s_%s_%s", projectId, f.Zone, f.Name)
		log.Infof("Connecting to cluster: %s,", name)
		cert, err := base64.StdEncoding.DecodeString(f.MasterAuth.ClusterCaCertificate)
		if err != nil {
			return &ret, fmt.Errorf("invalid certificate cluster=%s cert=%s: %w", name, f.MasterAuth.ClusterCaCertificate, err)
		}
		// example: gke_my-project_us-central1-b_cluster-1 => https://XX.XX.XX.XX
		proxy := ""
		if conf.PrivateEndpoint {
			proxy = "http://localhost:8888"
		}
		ret.Clusters[name] = &api.Cluster{
			CertificateAuthorityData: cert,
			Server:                   "https://" + f.Endpoint,
			ProxyURL:                 proxy,
		}
		// Just reuse the context name as an auth name.
		ret.Contexts[name] = &api.Context{
			Cluster:  name,
			AuthInfo: name,
		}
		// GCP specific configation; use cloud platform scope.
		ret.AuthInfos[name] = &api.AuthInfo{
			AuthProvider: &api.AuthProviderConfig{
				Name: "gcp",
				Config: map[string]string{
					"scopes": "https://www.googleapis.com/auth/cloud-platform",
				},
			},
		}
	}

	// Write kubeconfig to YAML file
	err = clientcmd.WriteToFile(ret, "kubeconfig")
	if err != nil {
		return &ret, err
	}
	return &ret, nil
}

// Verify `kubectl get` connectivity to all clusters
func ListNamespaces(kubeConfig *api.Config) error {
	ctx := context.Background()

	// Just list all the namespaces found in the project to  the API.
	for clusterName := range kubeConfig.Clusters {

		cfg, err := clientcmd.NewNonInteractiveClientConfig(*kubeConfig, clusterName, &clientcmd.ConfigOverrides{CurrentContext: clusterName}, nil).ClientConfig()
		if err != nil {
			return fmt.Errorf("failed to create Kubernetes configuration cluster=%s: %w", clusterName, err)
		}

		k8s, err := kubernetes.NewForConfig(cfg)
		if err != nil {
			return fmt.Errorf("failed to create Kubernetes client cluster=%s: %w", clusterName, err)
		}

		ns, err := k8s.CoreV1().Namespaces().List(ctx, metav1.ListOptions{})
		if err != nil {
			return fmt.Errorf("failed to list namespaces cluster=%s: %w", clusterName, err)
		}

		log.Infof("🌎 %d Namespaces found in cluster=%s", len(ns.Items), clusterName)
	}

	return nil
}

// Kubectl apply using client.go
func Apply(config *rest.Config, clusterName string, fileName []byte) error {

	dynamicClient, err := dynamic.NewForConfig(config)
	if err != nil {
		return fmt.Errorf("failed to setup dynamic client for cluster=%s: %w", clusterName, err)
	}
	discoveryClient, err := discovery.NewDiscoveryClientForConfig(config)
	if err != nil {
		return fmt.Errorf("failed to setup diecovery client for cluster=%s: %w", clusterName, err)
	}

	applyOptions := apply.NewApplyOptions(dynamicClient, discoveryClient)
	if err := applyOptions.Apply(context.TODO(), fileName); err != nil {
		return fmt.Errorf("failed to create apply gateway crd cluster=%s: %w", clusterName, err)
	}

	return nil
}

// check namespace and watch if not created
func WaitForNamespace(k8s *kubernetes.Clientset, ctx context.Context, nameSpace string, clusterName string) error {
	ns, err := k8s.CoreV1().Namespaces().Get(ctx, "config-management-system", metav1.GetOptions{})
	timeout := int64(120)
	if clientgo.IsNotFound(err) {
		log.Infof("%s was not found on cluster=%s: %v", nameSpace, clusterName, err)
		ns, err := k8s.CoreV1().Namespaces().Watch(ctx, metav1.ListOptions{
			FieldSelector:  "metadata.name=" + nameSpace,
			Watch:          true,
			TimeoutSeconds: &timeout,
		})
		if err != nil {
			return fmt.Errorf("failed watch on namespace %s on cluster=%s: %v", nameSpace, clusterName, err)
		}
		log.Infof("%s is ready on cluster: %s", ns, clusterName)

	} else if err != nil {
		return fmt.Errorf("%s namespace on cluster=%s: %w", nameSpace, clusterName, err)
	}
	log.Infof("%s is ready on cluster: %s", ns, clusterName)
	return nil
}
