#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"
echo -e "ASM_VERSION is ${ASM_VERSION}"
echo -e "ASM_PACKAGE is ${ASM_PACKAGE}"
echo -e "TARGET_CLUSTER is ${TARGET_CLUSTER}"
echo -e "TARGET_LOCATION is ${TARGET_LOCATION}"

# Download ASM installation package for istioctl bin
cd ${MODULE_PATH}
if [[ $OSTYPE == 'darwin'* ]]; then
    export ASM_PACKAGE_OS="${ASM_PACKAGE}-osx.tar.gz"
else 
    export ASM_PACKAGE_OS="${ASM_PACKAGE}-linux-amd64.tar.gz"
fi
curl -LO https://storage.googleapis.com/gke-release/asm/"${ASM_PACKAGE_OS}"
tar xzf ${ASM_PACKAGE_OS} && rm -rf ${ASM_PACKAGE_OS}
ISTIOCTL_CMD=$(pwd)/${ASM_PACKAGE}/bin/istioctl

${ISTIOCTL_CMD} version

# Get cluster creds
touch ./tempkubeconfig && export KUBECONFIG=./tempkubeconfig
gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT_ID}

# Create kubeconfig secret for the current cluster and install it in istio-system of the rest of the mesh clusters
${ISTIOCTL_CMD} x create-remote-secret --name=${CLUSTER} > ./manifests/secret-kubeconfig-${CLUSTER}.yaml

gcloud container clusters get-credentials ${TARGET_CLUSTER} --region ${TARGET_LOCATION} --project ${PROJECT_ID}
kubectl apply -f ./manifests/secret-kubeconfig-${CLUSTER}.yaml 