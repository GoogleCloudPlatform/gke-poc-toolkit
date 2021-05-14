#!/usr/bin/env bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o pipefail

# Locate the root directory
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source "${ROOT}/scripts/common.sh"

# Configure the connfig connector with the project GKE was created in.
cat <<EOF | kubectl apply -f -
apiVersion: core.cnrm.cloud.google.com/v1beta1
kind: ConfigConnector
metadata:
  name: configconnector.core.cnrm.cloud.google.com
spec:
  mode: cluster
  googleServiceAccount: "${1}-endpoint-cluster-kcc@${PROJECT}.iam.gserviceaccount.com" 
EOF

# Generate the variables to be used by Terraform
source "${ROOT}/scripts/generate-security-tfvars.sh"

# Initialize and run Terraform
if [ "$STATE" == gcs ]; then
  cd "${ROOT}/terraform/cluster_build"
  sed -i "s/local/gcs/g" backend.tf
  if [[ $(gsutil ls | grep "$PROJECT-$1-cluster-tf-state/") ]]; then
   echo "state bucket exists"
  else
   gsutil mb gs://$PROJECT-$1-cluster-tf-state
  fi
   (cd "${ROOT}/terraform/cluster_build"; terraform init -input=false -backend-config="bucket=$PROJECT-$1-cluster-tf-state")
   (cd "${ROOT}/terraform/cluster_build"; terraform apply -input=false -auto-approve) 
   
  
fi
if [ "$STATE" == local ]; then
 cd "${ROOT}/terraform/cluster_build"
 sed -i "s/gcs/local/g" backend.tf
 (cd "${ROOT}/terraform/cluster_build"; terraform init -input=false)
 (cd "${ROOT}/terraform/cluster_build"; terraform apply -input=false -auto-approve)
 GET_CREDS="$(terraform output --state=./terraform/$1/terraform.tfstate get_credentials)"
fi


