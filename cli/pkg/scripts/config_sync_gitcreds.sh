#!/bin/sh
set -x 

echo "Starting config sync git creds..."

echo "Getting credentials..."
echo "Project: $PROJECT_ID, Cluster name is: $CLUSTER_NAME, Region: $CLUSTER_REGION"
gcloud container clusters get-credentials ${CLUSTER_NAME} --project ${PROJECT_ID} --region ${CLUSTER_REGION}

DIR=`pwd`
echo "Current working dir is: $DIR"

#TODO - make start proxy 

# Create gitcreds secret. This allows Config Sync to use the previously-generated 
# SSH key to read from the user's CSR repo. 
echo "Creating gitcreds secret..."
kubectl create secret generic git-creds \
--namespace=config-management-system \
--from-file=ssh=../../pkg/scripts/.ssh/id_rsa
