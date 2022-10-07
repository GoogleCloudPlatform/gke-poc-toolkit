#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"
echo -e "GATEWAY_API_VERSION is ${GATEWAY_API_VERSION}"

# Setup kubeconfig
export WORKDIR=`pwd`
echo -e "Adding cluster ${CLUSTER} to kubeconfig located at ${WORKDIR}/tempkubeconfig"
echo -e "Creating tempkubeconfig."
rm ./tempkubeconfig
touch ./tempkubeconfig
export KUBECONFIG=${WORKDIR}/tempkubeconfig

# Get cluster creds
gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT_ID}

# Install Gateway API CRDs
echo -e "Installing GatewayAPI CRDs"

# Gateway api crds need to be installed in a specific order, this is temporary.
# kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=${GATEWAY_API_VERSION}" \
# | kubectl apply --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER} -f - 2>&1 >/dev/null

kubectl apply -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.4.2" --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}

kubectl apply -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.3.0" --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}

# Verify CRD is established in the cluster
echo -e "Validating GatewayAPI CRD creation"
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/backendpolicies.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/gatewayclasses.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/httproutes.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/gateways.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/tcproutes.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/tlsroutes.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/udproutes.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}

