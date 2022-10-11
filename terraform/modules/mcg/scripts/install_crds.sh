#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"
echo -e "GATEWAY_API_VERSION is ${GATEWAY_API_VERSION}"

export WORKDIR=`pwd`
kubeconfig=tempkubeconfig$RANDOM
echo -e "Adding cluster ${CLUSTER} to kubeconfig located at ${WORKDIR}/tempkubeconfig"
echo -e "Creating tempkubeconfig."
rm ${WORKDIR}/${kubeconfig}
touch ${WORKDIR}/${kubeconfig}
export KUBECONFIG=${WORKDIR}/${kubeconfig}

# Get cluster creds
gcloud beta container fleet memberships get-credentials ${CLUSTER}-membership --project ${PROJECT_ID}
CONTEXT=`kubectl config view -o jsonpath='{.users[*].name}' --kubeconfig ${KUBECONFIG} | grep ${CLUSTER}`

#gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT_ID}

# Install Gateway API CRDs
echo -e "Installing GatewayAPI CRDs"

kubectl apply -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.4.2" --kubeconfig ${KUBECONFIG} --context=${CONTEXT}

kubectl apply -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.3.0" --kubeconfig ${KUBECONFIG} --context=${CONTEXT}

# Verify CRD is established in the cluster
echo -e "Validating GatewayAPI CRD creation"
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/backendpolicies.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=${CONTEXT}
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/gatewayclasses.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=${CONTEXT}
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/httproutes.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=${CONTEXT}
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/gateways.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=${CONTEXT}
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/tcproutes.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=${CONTEXT}
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/tlsroutes.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=${CONTEXT}
kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/udproutes.networking.x-k8s.io --timeout=10m --kubeconfig ${KUBECONFIG} --context=${CONTEXT}

