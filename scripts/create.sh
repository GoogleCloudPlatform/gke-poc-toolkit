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

# shellcheck source=scripts/common.sh
source "${ROOT}/scripts/common.sh"

# Initialize and run Terraform
if [ "$STATE" == gcs ]; then
  if [[ $(gsutil ls | grep "$BUCKET/") ]]; then
    echo "state $BUCKET exists"
  else
    gsutil mb gs://$BUCKET
  fi
fi

case $STATE in

  local)
  (cd "${TERRAFORM_ROOT}";terraform init -input=true);
  (cd "${TERRAFORM_ROOT}";terraform apply -input=false -auto-approve -compact-warnings);
  GET_CREDS="$(terraform output get_credentials)";
  ;;
	
  gcs)	
	(cd "${TERRAFORM_ROOT}";terraform init -input=true -backend-config="bucket=${BUCKET}");
  (cd "${TERRAFORM_ROOT}";terraform apply -input=false -auto-approve -compact-warnings);
  GET_CREDS="$(terraform output get_credentials)";
  ;;

  *) exit 1
  ;;
esac