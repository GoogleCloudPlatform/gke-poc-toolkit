package lifecycle

import (
	"context"
	"fmt"
	"strings"

	gateway "cloud.google.com/go/gkeconnect/gateway/apiv1"
	gatewaypb "cloud.google.com/go/gkeconnect/gateway/apiv1/gatewaypb"
	log "github.com/sirupsen/logrus"
	"google.golang.org/api/cloudresourcemanager/v1"
	"google.golang.org/api/gkehub/v1"
	"google.golang.org/api/option"
	"k8s.io/client-go/tools/clientcmd"
	clientcmdapi "k8s.io/client-go/tools/clientcmd/api"
)

// GenerateKubeConfig generates a kubeconfig with contexts for all clusters in the GKE Demo Environment.
func GenerateKubeConfig(fleetProjectId string) (*clientcmdapi.Config, error) {

	// Create a GKE Hub client.
	ctx := context.Background()
	hubClient, err := gkehub.NewService(ctx, option.WithEndpoint("https://gkehub.googleapis.com/v1"))
	if err != nil {
		log.Errorf("Failed to create GKE Hub client: %v", err)
		return nil, err
	}

	// Get a list of all GKE Fleet memberships in the project.
	parent := fmt.Sprintf("projects/%s/locations/-", fleetProjectId)
	req := hubClient.Projects.Locations.Memberships.List(parent)
	memberships, err := req.Do()
	if err != nil {
		log.Errorf("Failed to list memberships: %v", err)
		return nil, err
	}

	// Get the project number for the fleet project needed later in the generate credentials request
	projectNumber, err := getProjectNumber(fleetProjectId)
	if err != nil {
		log.Errorf("Failed to get project number: %v", err)
		return nil, err
	}

	// Create a new kubeconfig.
	config := clientcmdapi.NewConfig()

	// Keep track of failed memberships
	failedMemberships := []string{}

	// Generate credentials for each membership
	for _, membership := range memberships.Resources {
		membershipName := membership.Name
		membershipLocation := extractLocation(membershipName)

		// Create a Gateway Control Client.
		endpoint := "connectgateway.googleapis.com"
		if isRegionalMembership(membershipName) {
			endpoint = membershipLocation + "-" + endpoint // Use regional endpoint
		} else {
			endpoint = "connectgateway.googleapis.com" // Use global endpoint
		}

		// Create a Gateway Control Client with the correct endpoint
		ctx2 := context.Background()
		gcc, err := gateway.NewGatewayControlRESTClient(ctx2, option.WithEndpoint(endpoint))
		if err != nil {
			log.Errorf("Failed to create gateway control client for %s: %v", membershipName, err)
			failedMemberships = append(failedMemberships, membershipName)
			continue // Skip to the next membership
		}
		defer gcc.Close()

		log.Infof("Generating credentials for membership: %s", membershipName)

		// Construct the correct membership name with project number
		membershipName = fmt.Sprintf("projects/%s/locations/%s/memberships/%s",
			projectNumber, membershipLocation, extractMembershipID(membership.Name))

		// Generate credentials for each membership
		req := &gatewaypb.GenerateCredentialsRequest{
			Name: membershipName,
		}
		resp, err := gcc.GenerateCredentials(ctx, req)
		if err != nil {
			log.Errorf("Failed to generate credentials for membership %s: Endpoint: %s, Error: %v", membershipName, endpoint, err)
			failedMemberships = append(failedMemberships, membershipName)
			continue // Skip to the next membership
		}

		// Get the kubeconfig from the response
		kc := resp.GetKubeconfig()

		// Parse the kubeconfig
		parsedConfig, err := clientcmd.Load(kc)
		if err != nil {
			log.Errorf("Failed to load kubeconfig for membership %s: %v", membershipName, err)
			return nil, err
		}

		// Merge the parsed config into the main config
		for key, context := range parsedConfig.Contexts {
			config.Contexts[key] = context
		}
		for key, cluster := range parsedConfig.Clusters {
			config.Clusters[key] = cluster
		}
		for key, authInfo := range parsedConfig.AuthInfos {
			config.AuthInfos[key] = authInfo
		}
	}

	// Write the kubeconfig to a file.
	err = clientcmd.WriteToFile(*config, "kubeconfig")
	if err != nil {
		log.Errorf("Failed to write kubeconfig: %v", err)
		return nil, err
	}
	if len(failedMemberships) > 0 {
		log.Warnf("Failed to generate credentials for the following memberships: %v", failedMemberships)
	} else {
		log.Info("Kubeconfig generated successfully.")
	}
	return config, err
}

func isRegionalMembership(membership string) bool {
	// A membership is regional if the membership.name string does not contain "locations/global"
	return !strings.Contains(membership, "locations/global")
}

func extractLocation(path string) string {
	parts := strings.Split(path, "/")
	for i, part := range parts {
		if part == "locations" && i+1 < len(parts) {
			return parts[i+1]
		}
	}
	return ""
}

func extractMembershipID(membershipName string) string {
	parts := strings.Split(membershipName, "/")
	return parts[len(parts)-1]
}

func getProjectNumber(projectID string) (string, error) {
	ctx := context.Background()
	crmService, err := cloudresourcemanager.NewService(ctx)
	if err != nil {
		return "", fmt.Errorf("failed to create Resource Manager client: %v", err)
	}

	project, err := crmService.Projects.Get(projectID).Do()
	if err != nil {
		return "", fmt.Errorf("failed to get project: %v", err)
	}

	return fmt.Sprintf("%d", project.ProjectNumber), nil
}
