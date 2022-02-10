#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"

# Create kubeconfig and get cluster creds
echo -e "Adding cluster ${CLUSTER} to kubeconfig located at ${PWD}/tempkubeconfig"
if [[ ! -e ./tempkubeconfig ]]; then
    touch ./tempkubeconfig
fi
export KUBECONFIG=./tempkubeconfig
gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT_ID}

# Download ASM installation package for istioctl bin
if [[ ! -e ./${ASM_PACKAGE}/bin/istioctl ]]; then
    if [[ ${OSTYPE} == 'darwin'* ]]; then
        export ASM_PACKAGE_OS="${ASM_PACKAGE}-osx.tar.gz"
    else 
        export ASM_PACKAGE_OS="${ASM_PACKAGE}-linux-amd64.tar.gz"
    fi
    curl -LO https://storage.googleapis.com/gke-release/asm/"${ASM_PACKAGE_OS}"
    tar xzf ${ASM_PACKAGE_OS} && rm -rf ${ASM_PACKAGE_OS}
fi