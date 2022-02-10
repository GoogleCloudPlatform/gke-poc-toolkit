#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"
echo -e "GATEWAY_API_VERSION is ${GATEWAY_API_VERSION}"

# Get cluster creds
echo -e "Setting up kubeconfig at ./mcgkubeconfig"
touch ./mcgkubeconfig && export KUBECONFIG=./mcgkubeconfig
gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT_ID}

# Install Gateway API CRDs
echo -e "Installing GatewayAPI CRDs"
kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=${GATEWAY_API_VERSION}" \
| kubectl apply -f -

# Verify CRD is established in the cluster
echo -e "Validating GatewayAPI CRD creation"
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/backendpolicies.networking.x-k8s.io --timeout=10m
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/gatewayclasses.networking.x-k8s.io --timeout=10m
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/httproutes.networking.x-k8s.io --timeout=10m
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/gateways.networking.x-k8s.io --timeout=10m
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/tcproutes.networking.x-k8s.io --timeout=10m
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/tlsroutes.networking.x-k8s.io --timeout=10m
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/udproutes.networking.x-k8s.io --timeout=10m

