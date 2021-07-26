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
TERRAFORM_ROOT="${ROOT}/terraform/cluster_build"
# Tear down Terraform-managed resources and remove generated tfvars

# Perform the destroy

if [ -f backend.tf ]; then 
		(cd "${TERRAFORM_ROOT}";terraform state rm "module.kms")
		(cd "${TERRAFORM_ROOT}"; terraform destroy -input=false -auto-approve)
		rm -f "${TERRAFORM_ROOT}/terraform.tfvars"
		gsutil -m rm -r gs://$BUCKET
	else
		(cd "${TERRAFORM_ROOT}"; terraform destroy -input=false -auto-approve)
		rm -f "${TERRAFORM_ROOT}/terraform.tfvars"
		rm -f "${TERRAFORM_ROOT}/terraform.tfstate"
		rm -rf "${TERRAFORM_ROOT}/.terraform"
fi


