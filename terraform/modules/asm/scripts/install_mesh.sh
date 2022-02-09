#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"

# Get cluster creds
echo -e "Setting up kubeconfig at ${MODULE_PATH}/asmkubeconfig"
cd ${MODULE_PATH}
touch ./asmkubeconfig && export KUBECONFIG=./asmkubeconfig
gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT_ID}

# Enable ASM Mesh which installs ASM CRDs
echo -e "Enabling ASM Mesh on the GKE HUB"
gcloud beta container hub mesh enable --project=${PROJECT_ID}

# Verify CRD is established in the cluster
echo -e "Verifying Control Plane Revisions CRD is present on ${CLUSTER}"
kubectl wait --for=condition=established crd controlplanerevisions.mesh.cloud.google.com --timeout=10m

# Install SAs, Roles, Roledbinding for ASM
kubectl apply -f ./manifests/istio-system-ns.yaml
kubectl apply -f ./manifests/