#!/usr/bin/env bash

# Verify variables
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"
echo -e "GATEWAY_API_VERSION is ${GATEWAY_API_VERSION}"

# Get cluster creds
touch ./kubeconfig && export KUBECONFIG=./kubeconfig
gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT}

# Install Gateway API CRDs
kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=${GATEWAY_API_VERSION}" \
| kubectl apply -f -

# Verify CRD is established in the cluster
# kubectl wait --for=condition=established crd customresourcedefinition.apiextensions.k8s.io/backendpolicies.networking.x-k8s.io --timeout=10m
# kubectl wait --for=condition=established crd customresourcedefinition.apiextensions.k8s.io/gatewayclasses.networking.x-k8s.io --timeout=10m
# kubectl wait --for=condition=established crd customresourcedefinition.apiextensions.k8s.io/httproutes.networking.x-k8s.io --timeout=10m
# kubectl wait --for=condition=established crd customresourcedefinition.apiextensions.k8s.io/gateways.networking.x-k8s.io --timeout=10m
# kubectl wait --for=condition=established crd customresourcedefinition.apiextensions.k8s.io/tcproutes.networking.x-k8s.io --timeout=10m
# kubectl wait --for=condition=established crd customresourcedefinition.apiextensions.k8s.io/tlsroutes.networking.x-k8s.io --timeout=10m
# kubectl wait --for=condition=established crd customresourcedefinition.apiextensions.k8s.io/udproutes.networking.x-k8s.io --timeout=10m

rm ./kubeconfig