#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"
echo -e "ASM_VERSION is ${ASM_VERSION}"
echo -e "ASM_PACKAGE is ${ASM_PACKAGE}"
echo -e "TARGET_CLUSTER is ${TARGET_CLUSTER}"
echo -e "TARGET_LOCATION is ${TARGET_LOCATION}"

# Setup Istio
export WORKDIR=`pwd`
ISTIOCTL_CMD=./${ASM_PACKAGE}/bin/istioctl

# Setup kubeconfig
export KUBECONFIG=${WORKDIR}/tempkubeconfig

echo -e "KUBECONFIG set to: ${KUBECONFIG}"

# Create kubeconfig secret for the current cluster and install it in istio-system of the rest of the mesh clusters
if [[ ${CLUSTER} != ${TARGET_CLUSTER} ]]; then
    echo -e "Creating kubeconfig secret from cluster ${CLUSTER} and installing it on cluster ${TARGET_CLUSTER}"
    ${ISTIOCTL_CMD} x create-remote-secret --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER} --name=${CLUSTER} > ./manifests/secret-kubeconfig-${CLUSTER}.yaml
    kubectl apply -f ./manifests/secret-kubeconfig-${CLUSTER}.yaml --kubeconfig=${KUBECONFIG} --context=gke_${PROJECT_ID}_${TARGET_LOCATION}_${TARGET_CLUSTER}
else
    echo -e "Skipping as the current cluster, ${CLUSTER}, is the same as the target cluster, ${TARGET_CLUSTER}"
fi
