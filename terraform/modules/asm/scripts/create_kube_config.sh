#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"
echo -e "ASM_PACKAGE is ${ASM_PACKAGE}"

# Create kubeconfig and get cluster creds
export WORKDIR=`pwd`
echo -e "Adding cluster ${CLUSTER} to kubeconfig located at ${WORKDIR}/tempkubeconfig"
if [[ ! -e ./tempkubeconfig ]]; then
    echo -e "Creating tempkubeconfig."
    touch ./tempkubeconfig
fi
echo -e "tempkubeconfig already exists."
export KUBECONFIG=${WORKDIR}/tempkubeconfig
gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT_ID}

# Download ASM installation package for istioctl bin
if [[ ! -e ${ASM_PACKAGE}/bin/istioctl ]]; then
    if [[ ${OSTYPE} == 'darwin'* ]]; then
        export ASM_PACKAGE_OS="${ASM_PACKAGE}-osx.tar.gz"
    else 
        export ASM_PACKAGE_OS="${ASM_PACKAGE}-linux-amd64.tar.gz"
    fi
    curl -LO https://storage.googleapis.com/gke-release/asm/"${ASM_PACKAGE_OS}"
    tar xzf ${ASM_PACKAGE_OS}
fi