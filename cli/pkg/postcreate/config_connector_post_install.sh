#!/bin/sh

set -x 

# NOTE - this script is used for one cluster at a time. 

# Get cluster credentials 
# TODO - this will work only with zonal clusters 
echo "☁️ Config Connector post-install for cluster: ${CLUSTER_NAME} in zone: ${CLUSTER_ZONE}"

gcloud container clusters get-credentials ${CLUSTER_NAME} --project ${PROJECT_ID} --zone=${CLUSTER_ZONE}

# inject project ID into configconnector.yaml 
sed -i "s/PROJECT_ID/$PROJECT_ID/g" ../../pkg/postcreate/config-connector/configconnector.yaml 
kubectl apply -f ../../pkg/postcreate/config-connector/configconnector.yaml

# inject project ID into gcp-namespace.yaml 
sed -i "s/PROJECT_ID/$PROJECT_ID/g" ../../pkg/postcreate/config-connector/gcp-namespace.yaml 
kubectl apply -f ../../pkg/postcreate/config-connector/gcp-namespace.yaml

# Apply a test GCP resource 
# (Note - this is applied directly via kubectl rather than config sync, because right now we allow to have the user enable Config Connector but *not* enable Config Sync.)
kubectl apply -f ../../pkg/postcreate/config-connector/test-service-account.yaml 
