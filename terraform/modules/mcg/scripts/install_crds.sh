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
CONTEXT=`kubectl config view -o jsonpath='{.users[0].name}' --kubeconfig ${KUBECONFIG}`
# Install Gateway API CRDs
echo -e "Installing GatewayAPI CRDs"

kubectl apply -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.5.0" --kubeconfig ${KUBECONFIG} --context=${CONTEXT}