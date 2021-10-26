# Copyright © 2021 Google Inc.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash
set -x 

# NOTE - this script is used for one cluster at a time. 

# Get cluster credentials 
# TODO - this will work only with zonal clusters 
gcloud container clusters get-credentials ${CLUSTER_NAME} --project ${PROJECT_ID} --zone=${CLUSTER_ZONE}

# inject project ID into configconnector.yaml 
sed -i "s/PROJECT_ID/$PROJECT_ID/g" config-connector/configconnector.yaml 
kubectl apply -f config-connector/configconnector.yaml

# inject project ID into gcp-namespace.yaml 
sed -i "s/PROJECT_ID/$PROJECT_ID/g" config-connector/gcp-namespace.yaml 
kubectl apply -f config-connector/gcp-namespace.yaml

# Apply a test GCP resource 
# (Note - this is applied directly via kubectl rather than config sync, because right now we allow to have the user enable Config Connector but *not* enable Config Sync.)
kubectl apply -f config-connector/test-service-account.yaml 
