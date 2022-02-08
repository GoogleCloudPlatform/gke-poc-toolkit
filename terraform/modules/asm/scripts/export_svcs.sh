#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"
echo -e "ASM_VERSION is ${ASM_VERSION}"
echo -e "TARGET_CLUSTER is ${TARGET_CLUSTER}"
echo -e "TARGET_LOCATION is ${TARGET_LOCATION}"

# Download ASM installation package for istioctl bin
curl -LO https://storage.googleapis.com/gke-release/asm/istio-${ASM_VERSION}-linux-amd64.tar.gz
tar xzf istio-${ASM_VERSION}-linux-amd64.tar.gz
ISTIOCTL_CMD=$(pwd)/istio-${ASM_VERSION}/bin/istioctl

${ISTIOCTL_CMD} version

# Get cluster creds
touch ./tempkubeconfig && export KUBECONFIG=./tempkubeconfig
gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT_ID}

# Create kubeconfig secret for the current cluster and install it in istio-system of the rest of the mesh clusters
${ISTIOCTL_CMD} x create-remote-secret --name=${CLUSTER} > secret-kubeconfig-${CLUSTER}.yaml

gcloud container clusters get-credentials ${TARGET_CLUSTER} --region ${TARGET_LOCATION} --project ${PROJECT_ID}
kubectl apply -f secret-kubeconfig-${CLUSTER}.yaml 
