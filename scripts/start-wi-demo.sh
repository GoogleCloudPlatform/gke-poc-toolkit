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

CONFIG_FILES_COUNT=$(ls demos/workload-identity | wc -l)

if [[ "$CONFIG_FILES_COUNT" != 1 ]]
then
    while true; do
        echo ""
         read -p "The workload identity demo config files already exist. If you would like to write over them Select yes(y) or no(n) to cancel execution: " yn ; tput sgr0 
        case $yn in
            [Yy]* ) echo "Config files will be overwritten"; rm ${TFVARS_FILE}; break;;
            [Nn]* ) echo "Cancelling execution";exit ;;
            * ) echo "Incorrect input. Cancelling execution";exit 1;;
        esac
    done
fi

# Generate the demo kubernetes configs 
# shellcheck source=scripts/generate-wi-demo-configs.sh
source "${ROOT}/scripts/generate-wi-demo-configs.sh"

# Set variables for the demo folder kubernets config location.
WORKLOAD_ID_DIR="./demos/workload-identity"


# Create the demo app namespace then the rest of the k8s objects.
kubectl apply -f ${WORKLOAD_ID_DIR}/gcs-wi-test-namespace.yaml
kubectl apply -f ${WORKLOAD_ID_DIR}/.