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
CONFIG=${WORKDIR}/${kubeconfig}

# Get cluster creds
gcloud beta container fleet memberships get-credentials ${CLUSTER}-membership --project ${PROJECT_ID}
# CONTEXT=`kubectl config view -o jsonpath='{.users[*].name}' --kubeconfig ${KUBECONFIG} | grep ${CLUSTER}`

# Install Gateway API CRDs
echo -e "Installing GatewayAPI CRDs"

kubectl apply -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.5.0" --kubeconfig=$CONFIG

# # Verify CRD is established in the cluster
# echo -e "Validating GatewayAPI CRD creation"
# until kubectl get crd gatewayclasses.gateway.networking.k8s.io
# do
#   echo -n "...still waiting for the gatewayclasses crd creation"
#   sleep 1
# done
# until kubectl get crd httproutes.gateway.networking.k8s.io
# do
#   echo -n "...still waiting for the httproutes crd creation"
#   sleep 1
# done
# until kubectl get crd gateways.gateway.networking.k8s.io
# do
#   echo -n "...still waiting for the httproutes crd creation"
#   sleep 1
# done
# kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/gatewayclasses.gateway.networking.k8s.io --timeout=10m
# kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/ --timeout=10m
# kubectl wait --for=condition=established customresourcedefinition.apiextensions.k8s.io/gateways.gateway.networking.k8s.io --timeout=10m
