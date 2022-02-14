#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"
echo -e "ASM_VERSION is ${ASM_VERSION}"
echo -e "ASM_PACKAGE is ${ASM_PACKAGE}"

# Setup Istio
export WORKDIR=`pwd`
ISTIOCTL_CMD=./${ASM_PACKAGE}/bin/istioctl

# Setup kubeconfig
export KUBECONFIG=${WORKDIR}/tempkubeconfig

echo -e "KUBECONFIG set to: ${KUBECONFIG}"

# Create kubeconfig secret for the current cluster and install it in istio-system of the rest of the mesh clusters
${ISTIOCTL_CMD} x create-remote-secret --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER} --name=${CLUSTER} > ./manifests/secret-kubeconfig-${CLUSTER}.yaml

for i in `gcloud container clusters list --project ${PROJECT_ID} --format="value(name)"`; do
    if [[ "$i" != "${CLUSTER}" ]]; then
        TARGET_CONTEXT=`kubectl config get-contexts | grep ${i} | awk '{print $2}'`
        echo -e "Creating kubeconfig secret from cluster ${CLUSTER} and installing it on cluster ${i}"
        kubectl apply -f ./manifests/secret-kubeconfig-${CLUSTER}.yaml --kubeconfig=${KUBECONFIG} --context=${TARGET_CONTEXT}
    else
        echo -e "Skipping as the current cluster, ${CLUSTER}, is the same as the target cluster, ${i}"
    fi
done
