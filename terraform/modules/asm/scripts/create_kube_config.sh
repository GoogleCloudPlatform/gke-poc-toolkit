#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "ASM_PACKAGE is ${ASM_PACKAGE}"

# Download istioctl
if [[ ${OSTYPE} == 'darwin'* ]]; then
    export ASM_PACKAGE_OS="${ASM_PACKAGE}-osx.tar.gz"
else 
    export ASM_PACKAGE_OS="${ASM_PACKAGE}-linux-amd64.tar.gz"
fi
curl -LO https://storage.googleapis.com/gke-release/asm/"${ASM_PACKAGE_OS}"
tar xzf ${ASM_PACKAGE_OS}

# Create kubeconfig and get cluster creds
export WORKDIR=`pwd`
echo -e "Adding cluster ${CLUSTER} to kubeconfig located at ${WORKDIR}/tempkubeconfig"
echo -e "Creating tempkubeconfig."
touch ./tempkubeconfig
export KUBECONFIG=${WORKDIR}/tempkubeconfig

declare -t CLUSTER_NAMES=()
for i in `gcloud container clusters list --project ${PROJECT_ID} --format="value(name)"`; do
    CLUSTER_NAMES+=("$i")
done

declare -t CLUSTER_LOCATIONS=()
for i in `gcloud container clusters list --project ${PROJECT_ID} --format="value(location)"`; do
    CLUSTER_LOCATIONS+=("$i")
done

declare -A NAMES_LOCATIONS
for ((i=0; $i<${#CLUSTER_NAMES[@]}; i++))
do
    NAMES_LOCATIONS+=( ["${CLUSTER_NAMES[i]}"]="${CLUSTER_LOCATIONS[i]}" )
done

for CLUSTER_NAME in "${!NAMES_LOCATIONS[@]}"; do
    gcloud container clusters get-credentials $CLUSTER_NAME --region ${NAMES_LOCATIONS[$CLUSTER_NAME]} --project ${PROJECT_ID}
done

NUM_CONTEXTS=`kubectl config view -o jsonpath='{.users[*].name}' | wc -w`
NUM_CLUSTERS=`gcloud container clusters list --project ${PROJECT_ID} --format="value(name)" | wc -l`
if [[ ${NUM_CONTEXTS} != ${NUM_CLUSTERS} ]]; then
    echo -e "There was an error getting credentials for all the gketoolkit clusters"
    exit 1
else
    echo -e "Kubeconfig is setup with all gketoolkit clusters credentials"
fi
