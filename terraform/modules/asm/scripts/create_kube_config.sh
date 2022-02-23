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

# Enable ASM Mesh which installs ASM CRDs
echo -e "Enabling ASM Mesh on the GKE HUB"
gcloud beta container hub mesh enable --project=${PROJECT_ID}

for i in {1..300}; do
    HUB_CHECK=`gcloud beta container hub memberships list --project=${PROJECT_ID} --format="value(name)" | wc -l | awk '{print $1}'`
    CLUSTER_CHECK=`gcloud container clusters list --project=${PROJECT_ID} --format="value(name)" | wc -l | awk '{print $1}'`
    if [[ ${HUB_CHECK} == ${CLUSTER_CHECK} ]]; then
        echo -e "All clusters are registered to the HUB"
        break
    else
        echo -e "Waiting for all clusters to show in the HUB for $i seconds. Current status - Hub Count: ${HUB_CHECK} Cluster Count: ${CLUSTER_CHECK}"
    fi
done

NUM_MEMBERS=`gcloud beta container hub memberships list --project=${PROJECT_ID} --format="value(name)" | wc -l | awk '{print $1}'`
echo -e "NUM_MEMBERS: ${NUM_MEMBERS}"
STATE_CODE="OK"
for (( c=$START; c<=$END; c++ ))

if [[ ${NUM_MEMBERS} -le 1 ]]; then
    echo -e "STATE_CODE: ${STATE_CODE}"
else
    for (( i=2; i<=${NUM_MEMBERS}; i++)); do
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
