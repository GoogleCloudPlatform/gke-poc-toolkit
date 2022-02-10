#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"

# Setup kubeconfig
echo -e "Setting up kubeconfig at ${MODULE_PATH}/tempkubeconfig"
cd ${MODULE_PATH}
export KUBECONFIG=./tempkubeconfig

# Enable ASM Mesh which installs ASM CRDs
echo -e "Enabling ASM Mesh on the GKE HUB"
gcloud beta container hub mesh enable --project=${PROJECT_ID}

NUM_MEMBERS=`gcloud beta container hub memberships list --project=${PROJECT_ID} --format="value(name)" | wc -l | awk '{print $1}'`
STATE_CODE="OK"
for i in {1..$NUM_MEMBERS}; do
    if [[ $i -eq 1 ]]; then
        echo ${STATE_CODE}
    else
        STATE_CODE="${STATE_CODE};OK"
    fi
done 

for i in {1..600}; do
    if [[ `gcloud beta container hub mesh describe --project=${PROJECT_ID} --format="value(membershipStates[].state.code)"` == ${STATE_CODE} ]]; then
        break
    else
        echo "Waiting on hub to install ASM in clusters for $i seconds."
    fi
done

# Verify CRD is established in the cluster
echo -e "Verifying Control Plane Revisions CRD is present on ${CLUSTER}"
kubectl wait --for=condition=established crd controlplanerevisions.mesh.cloud.google.com --timeout=10m \
    --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}

# Install SAs, Roles, Roledbinding for ASM
kubectl apply -f ./manifests/istio-system-ns.yaml
kubectl apply -f ./manifests/