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

# Generate the variables to be used by Terraform
source "${ROOT}/scripts/set-env.sh"
source "${ROOT}/scripts/generate-shared-vpc-tfvars.sh"

# # Initialize and run Terraform
# if [ "$STATE" == gcs ]; then
#   cd "${ROOT}/terraform/shared_vpc"
#   BUCKET=$PROJECT-$CLUSTER_TYPE-state  
#   sed -i "s/local/gcs/g" backend.tf
#   if [[ $(gsutil ls | grep "$BUCKET/") ]]; then
#    echo "state $BUCKET exists"
#   else
#    gsutil mb gs://$BUCKET
#   fi
#    (cd "${ROOT}/terraform/shared_vpc"; terraform init -input=true -backend-config="bucket=$BUCKET")
#    (cd "${ROOT}/terraform/shared_vpc"; terraform apply -input=false -auto-approve)
#    sed '/^BUCKET/d' ${ROOT}/scripts/set-env.sh
#    echo -e "export BUCKET=${BUCKET}" >> ${ROOT}/scripts/set-env.sh 
#    GET_CREDS="$(terraform output  get_credentials)" 
  
# fi
# if [ "$STATE" == local ]; then
#  cd "${ROOT}/terraform/shared_vpc"
#  sed -i "s/gcs/local/g" backend.tf
#  (cd "${ROOT}/terraform/shared_vpc"; terraform init -input=false)
#  (cd "${ROOT}/terraform/shared_vpc"; terraform apply -input=false -auto-approve)
#  GET_CREDS="$(terraform output --state=./terraform/$1/terraform.tfstate get_credentials)"
# fi