#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"

# Setup kubeconfig
export WORKDIR=`pwd`
echo -e "Setting up kubeconfig at ${WORKDIR}/tempkubeconfig"
export KUBECONFIG=${WORKDIR}/tempkubeconfig

# Enable ASM Mesh which installs ASM CRDs
echo -e "Enabling ASM Mesh on the GKE HUB"
gcloud beta container hub mesh enable --project=${PROJECT_ID}

NUM_MEMBERS=`gcloud beta container hub memberships list --project=${PROJECT_ID} --format="value(name)" | wc -l | awk '{print $1}'`
echo -e "NUM_MEMBERS: ${NUM_MEMBERS}"
STATE_CODE="OK"
if [[ ${NUM_MEMBERS} -le 1 ]]; then
    echo -e "STATE_CODE: ${STATE_CODE}"
else
    for i in {2..${NUM_MEMBERS}}; do
        STATE_CODE="${STATE_CODE};OK"
    done
    echo -e "STATE_CODE: ${STATE_CODE}"
fi

for i in {1..900}; do
    STATUS=`gcloud beta container hub mesh describe --project=${PROJECT_ID} --format="value(membershipStates[].state.code)"`
    if [[ ${STATUS} == ${STATE_CODE} ]]; then
        echo -e "Hub mesh membership stats all OK"
        break
    else
        echo -e "Waiting on hub to install ASM in clusters for $i seconds. Current status:${STATUS}. Expected status ${STATE_CODE}"
    fi
done

# Verify CRD is established in the cluster
echo -e "Verifying Control Plane Revisions CRD is present on ${CLUSTER}"
kubectl wait --for=condition=established crd controlplanerevisions.mesh.cloud.google.com --timeout=10m \
    --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}

# Install SAs, Roles, Roledbinding for ASM
kubectl apply -f ./manifests/istio-system-ns.yaml --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}
kubectl apply -f ./manifests/ --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}

kubectl wait --for=condition=ProvisioningFinished controlplanerevision -n istio-system asm-managed --timeout=10m --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}