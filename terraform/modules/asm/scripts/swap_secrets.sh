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
if [[ ${OSTYPE} == 'darwin'* ]]; then
    export ASM_PACKAGE_OS="${ASM_PACKAGE}-osx.tar.gz"
else 
    export ASM_PACKAGE_OS="${ASM_PACKAGE}-linux-amd64.tar.gz"
fi
curl -LO https://storage.googleapis.com/gke-release/asm/"${ASM_PACKAGE_OS}"
tar xzf ${ASM_PACKAGE_OS} && rm -rf ${ASM_PACKAGE_OS}
ISTIOCTL_CMD=./${ASM_PACKAGE}/bin/istioctl

# Setup kubeconfig
echo -e "Setting up kubeconfig at ${MODULE_PATH}/tempkubeconfig"
export KUBECONFIG=./tempkubeconfig

echo -e "KUBECONFIG set to: ${KUBECONFIG}"

# Create kubeconfig secret for the current cluster and install it in istio-system of the rest of the mesh clusters
if [[ ${CLUSTER} == ${TARGET_CLUSTER}]]; then
    break
else
    echo -e "Creating kubeconfig secret from cluster ${CLUSTER} and installing it on cluster ${TARGET_CLUSTER}"
    ${ISTIOCTL_CMD} x create-remote-secret --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER} --name=${CLUSTER} > ./manifests/secret-kubeconfig-${CLUSTER}.yaml
    kubectl apply -f ./manifests/secret-kubeconfig-${CLUSTER}.yaml --config=${KUBECONFIG} --context=gke_${PROJECT_ID}_${TARGET_LOCATION}_${TARGET_CLUSTER}
