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

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Sets up the gcloud compute ssh proxy to the bastion  -"
# "-                                                       -"
# "---------------------------------------------------------"

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -euo pipefail

# Directory of this script.
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# shellcheck source=scripts/common.sh
source "$ROOT"/scripts/common.sh

# Obtain the needed env variables. Variables are only created if they are
# currently empty. This allows users to set environment variables if they
# would prefer to do so.
#
# The - in the initial variable check prevents the script from exiting due
# from attempting to use an unset variable.
[[ -z "${PROJECT-}" ]] && PROJECT="$(gcloud config get-value core/project)"
if [[ -z "${PROJECT}" ]]; then
    echo "gcloud cli must be configured with a default project." 1>&2
    echo "run 'gcloud config set core/project PROJECT'." 1>&2
    echo "replace 'PROJECT' with the project name." 1>&2
    exit 1;
fi

# Check to for existing deployment configs. 
CONFIG_FILES_COUNT=$(ls demos/workload-identity | wc -l)

if [[ "$CONFIG_FILES_COUNT" != 0 ]]
then
    while true; do
        echo ""
         read -p "The workload identity demo config files already exist. If you would like to write over them Select yes(y) or no(n) to cancel execution: " yn ; tput sgr0 
        case $yn in
            [Yy]* ) echo "Config files will be overwritten";break;;
            [Nn]* ) echo "Cancelling execution";exit ;;
            * ) echo "Incorrect input. Cancelling execution";exit 1;;
        esac
    done
fi

# Configure the connfig connector with the project GKE was created in. 
# This is done in the hardening build already but I want to ensure this demo
# can run standalone. 

# Get KCC SA email
KCC_SA_EMAIL=$(gcloud iam service-accounts list | grep cluster-kcc | awk 'END{ print $4}')

cat <<EOF | kubectl apply -f -
apiVersion: core.cnrm.cloud.google.com/v1beta1
kind: ConfigConnector
metadata:
  name: configconnector.core.cnrm.cloud.google.com
spec:
  mode: cluster
  googleServiceAccount: "${KCC_SA_EMAIL}-endpoint-cluster-kcc@${PROJECT}.iam.gserviceaccount.com" 
EOF

# Generate the demo kubernetes configs 
source "${ROOT}/scripts/generate-wi-demo-configs.sh"

# Set variables for the demo folder kubernetes config location.
WORKLOAD_ID_DIR="./demos/workload-identity"

# Create the demo app namespace then the rest of the k8s objects.
kubectl apply -f ${WORKLOAD_ID_DIR}/gcs-wi-demo-namespace.yaml
kubectl apply -f ${WORKLOAD_ID_DIR}/.