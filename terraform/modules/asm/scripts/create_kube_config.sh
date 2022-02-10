#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"

# Create kubeconfig and get cluster creds
echo -e "Adding cluster ${CLUSTER} to kubeconfig located at ${PWD}/tempkubeconfig"
if [[ ! -e ./tempkubeconfig ]]; then
    touch ./tempkubeconfig
fi
export KUBECONFIG=./tempkubeconfig
gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT_ID}