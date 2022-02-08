#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"

# Get cluster creds
cd ${MODULE_PATH}
touch ./tempkubeconfig && export KUBECONFIG=./tempkubeconfig
gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT_ID}

# Enable ASM Mesh which installs ASM CRDs
gcloud beta container hub mesh enable --project=${PROJECT_ID}

# Verify CRD is established in the cluster
kubectl wait --for=condition=established crd controlplanerevisions.mesh.cloud.google.com --timeout=10m

# Install SAs, Roles, Roledbinding for ASM
kubectl apply -f ./manifests/istio-system-ns.yaml
kubectl apply -f ./manifests/