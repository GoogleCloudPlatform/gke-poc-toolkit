package anthos

import (
	"context"
	"encoding/base64"
	"fmt"
	"gkekitctl/pkg/config"

	"github.com/pytimer/k8sutil/apply"
	log "github.com/sirupsen/logrus"
	"google.golang.org/api/container/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/discovery"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/restmapper"
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

type client struct {
	c      dynamic.Interface
	config *rest.Config
	mapper *restmapper.DeferredDiscoveryRESTMapper
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
