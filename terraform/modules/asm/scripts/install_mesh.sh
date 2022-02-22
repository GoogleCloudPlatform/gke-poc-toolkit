#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"
echo -e "ASM_PACKAGE is ${ASM_PACKAGE}"

# Setup kubeconfig
export WORKDIR=`pwd`
echo -e "Setting up kubeconfig at ${WORKDIR}/tempkubeconfig"
export KUBECONFIG=${WORKDIR}/tempkubeconfig

# Verify CRD is established in the cluster
echo -e "Verifying Control Plane Revisions CRD is present on ${CLUSTER}"
kubectl wait --for=condition=established crd controlplanerevisions.mesh.cloud.google.com --timeout=20m \
    --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}

# Install SAs, Roles, Roledbinding for ASM
kubectl apply -f ./manifests/istio-system-ns.yaml --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}
kubectl apply -f ./manifests/ --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}

kubectl wait --for=condition=ProvisioningFinished controlplanerevision -n istio-system asm-managed --timeout=10m --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}

# Create kubeconfig secret for the current cluster and install it in istio-system of the rest of the mesh clusters
${ASM_PACKAGE}/bin/istioctl create-remote-secret --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER} --name=${CLUSTER} > ./manifests/secret-kubeconfig-${CLUSTER}.yaml

# while ! [[ -s ./manifests/secret-kubeconfig-${CLUSTER}.yaml ]]; do
#     ${ASM_PACKAGE}/bin/istioctl create-remote-secret --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER} --name=${CLUSTER} > ./manifests/secret-kubeconfig-${CLUSTER}.yaml
# sleep 5
# done
echo -e "${CLUSTER} secret was created here: /manifests/secret-kubeconfig-${CLUSTER}.yaml"

for i in `gcloud container clusters list --project ${PROJECT_ID} --format="value(name)"`; do
    if [[ "$i" != "${CLUSTER}" ]]; then
        echo $i
        TARGET_CONTEXT=`kubectl config get-contexts | grep ${i} | awk '{print $2}'`
        echo -e "Creating kubeconfig secret from cluster ${CLUSTER} and installing it on cluster ${i}"
        kubectl apply -f ./manifests/secret-kubeconfig-${CLUSTER}.yaml --kubeconfig=${KUBECONFIG} --context=${TARGET_CONTEXT}
    else
        echo -e "Skipping as the current cluster, ${CLUSTER}, is the same as the target cluster, ${i}"
    fi
done