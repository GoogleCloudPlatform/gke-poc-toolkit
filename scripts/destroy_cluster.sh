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

# Do not set errexit as it makes partial deletes impossible
set -o nounset
set -o pipefail

# Locate the root directory
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# shellcheck source=scripts/common.sh
source "$ROOT/scripts/common.sh"

# Tear down Terraform-managed resources and remove generated tfvars
cd "$ROOT/terraform/cluster_build" || exit;

# Perform the destroy

if [ "$2" == gcs ]; then 
   cd "${ROOT}/terraform/cluster_build"
   sed -i "s/local/gcs/g" backend.tf
   (cd "${ROOT}/terraform/cluster_build"; terraform init -input=false -backend-config="bucket=$PROJECT-$1-cluster-tf-state")
   (cd "${ROOT}/terraform/cluster_build"; terraform destroy -input=false -auto-approve) 
fi
if [ "$2" == local ]; then
 cd "${ROOT}/terraform/cluster_build"
 sed -i "s/gcs/local/g" backend.tf
 (cd "${ROOT}/terraform/cluster_build"; terraform init -input=false)
 (cd "${ROOT}/terraform/cluster_build"; terraform destroy -input=false -auto-approve)
fi

# Remove the tfvars file generated during "make create"
#rm -f "$ROOT/terraform/cluster_build/terraform.tfvars"
rm -f "$ROOT/terraform/cluster_build/terraform.tfstate"
