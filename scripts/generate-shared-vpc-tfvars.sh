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
# "-  Helper script to generate terraform variables        -"
# "-  file based on gcloud defaults.                       -"
# "-                                                       -"
# "---------------------------------------------------------"

# Stop immediately if something goes wrong
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source "$ROOT/scripts/common.sh"
source "$ROOT/scripts/set-env.sh"

TFVARS_FILE="./terraform/shared_vpc/terraform.tfvars"

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

[[ -z "${REGION-}" ]] && REGION="$(gcloud config get-value compute/region)"
if [[ -z "${REGION}" ]]; then
    echo "https://cloud.google.com/compute/docs/regions-zones/changing-default-zone-region" 1>&2
    echo "gcloud cli must be configured with a default region." 1>&2
    echo "run 'gcloud config set compute/region REGION'." 1>&2
    echo "replace 'REGION' with the region name like us-west1." 1>&2
    exit 1;
fi

# Verify Shared VPC environment variables are set
[[ -z "${SHARED_VPC_NAME-}" ]] && SHARED_VPC_NAME="$(echo $SHARED_VPC_NAME)"
if [[ -z "${SHARED_VPC_NAME}" ]]; then
    tput setaf 1; echo "" 1>&2
    echo "creating to a shared VPC requires the shared VPC name to be set." 1>&2
    echo "run 'export SHARED_VPC_NAME=<SHARED_VPC_NAME>'." 1>&2
    echo "replace <SHARED_VPC_NAME> with the shared VPC name." 1>&2
    echo "alternatively, changing the value of SHARED_VPC to false will create a standalone VPC in the service project where GKE is deployed." 1>&2
    echo "" ; tput sgr0
    exit 1;
fi

[[ -z "${SHARED_VPC_SUBNET_NAME-}" ]] && SHARED_VPC_SUBNET_NAME="$(echo $SHARED_VPC_SUBNET_NAME)"
if [[ -z "${SHARED_VPC_SUBNET_NAME}" ]]; then
    tput setaf 1; echo "" 1>&2        
    echo "creating a shared VPC requires the shared VPC subnet name to be set." 1>&2
    echo "run 'export SHARED_VPC_SUBNET_NAME=<SHARED_VPC_SUBNET_NAME>'." 1>&2
    echo "replace <SHARED_VPC_SUBNET_NAME> with the subnet name in the shared VPC where GKE is to be deployed." 1>&2
    echo "alternatively, changing the value of SHARED_VPC to false will create a standalone VPC in the service project where GKE is deployed." 1>&2
    echo "" ; tput sgr0
    exit 1;
fi

[[ -z "${SHARED_VPC_PROJECT_ID-}" ]] && SHARED_VPC_PROJECT_ID="$(echo $SHARED_VPC_PROJECT_ID)"
if [[ -z "${SHARED_VPC_PROJECT_ID}" ]]; then
    tput setaf 1; echo "" 1>&2
    echo "creating a shared VPC requires the shared VPC project ID to be set." 1>&2
    echo "run 'export SHARED_VPC_PROJECT_ID=<SHARED_VPC_PROJECT_ID>'." 1>&2
    echo "replace <SHARED_VPC_PROJECT_ID> with shared VPC project ID." 1>&2
    echo "alternatively, changing the value of SHARED_VPC to false will create a standalone VPC in the service project where GKE is deployed." 1>&2
    echo "" ; tput sgr0
    exit 1;
fi

[[ -z "${POD_IP_RANGE_NAME-}" ]] && POD_IP_RANGE_NAME="$(echo $POD_IP_RANGE_NAME)"
if [[ -z "${POD_IP_RANGE_NAME}" ]]; then
    tput setaf 1; echo "" 1>&2
    echo "creating a shared VPC requires a secondary IP range be created on the subnet and configured with the pod IP range for the cluster." 1>&2
    echo "run 'export POD_IP_RANGE_NAME=<POD_IP_RANGE_NAME>'." 1>&2
    echo "replace <POD_IP_RANGE_NAME> with the name of the secondary IP range created for pod IPs." 1>&2
    echo "alternatively, changing the value of SHARED_VPC to false will create a standalone VPC in the service project where GKE is deployed." 1>&2
    echo "" ; tput sgr0
    exit 1;
fi

[[ -z "${SERVICE_IP_RANGE_NAME-}" ]] && SERVICE_IP_RANGE_NAME="$(echo $SERVICE_IP_RANGE_NAME)"
if [[ -z "${SERVICE_IP_RANGE_NAME}" ]]; then
    tput setaf 1; echo "" 1>&2
    echo "creating a shared VPC requires a secondary IP range be created on the subnet and configured with the service IP range for the cluster." 1>&2
    echo "run 'export SERVICE_IP_RANGE_NAME=<SERVICE_IP_RANGE_NAME>'." 1>&2
    echo "replace <SERVICE_IP_RANGE_NAME> with the name of the secondary IP range created for service IPs." 1>&2
    echo "alternatively, changing the value of SHARED_VPC to false will create a standalone VPC in the service project where GKE is deployed." 1>&2
    echo "" ; tput sgr0
    exit 1;
fi

# Verify if the target Shared VPC already exists
#  - If it does, query admin for corrective action
if [[ "$(gcloud compute networks describe $SHARED_VPC_NAME --project $SHARED_VPC_PROJECT_ID -q 2>/dev/null | grep name | sed 's/^.*: //')" =~ "$SHARED_VPC_NAME" ]]; then
    echo ""
        read -p "a shared VPC named ${SHARED_VPC_NAME} already exists in host project $SHARED_VPC_PROJECT_ID. If this is from a previous deployment of this template, please select yes(y) to continue or no(n) to cancel and correct the issue: " yn ; tput sgr0 
    case $yn in
        [Yy]* ) echo "the deployment will attempt to leverage the existing Shared VPC";exit ;;
        [Nn]* ) echo "to resolve this conflict either delete the existing Shared VPC, choose a different project/VPC name or deploy to the existing Shared VPC";exit ;;
        * ) echo "Incorrect input. Cancelling execution";exit 1;;
    esac
else
    echo "create shared VPC" 1>&2
fi

if [[ "${STATE}" = "gcs" ]]; then
   STATE="gcs"
else
   STATE="local"
fi

# If Terraform is run without this file, the user will be prompted for values.
# This check verifies if the file exists and prompts user for deletion
# We don't want to overwrite a pre-existing tfvars file
if [[ -f "${TFVARS_FILE}" ]]
then
    while true; do
        echo ""
         read -p "${TFVARS_FILE} already exists indicating a previous execution. This file needs to be removed or renamed before rerunning the deployment. Select yes(y) to delete or no(n) to cancel execution: " yn ; tput sgr0 
        case $yn in
            [Yy]* ) echo "Deleting and recreating ${TFVARS_FILE}"; rm ${TFVARS_FILE}; break;;
            [Nn]* ) echo "Cancelling execution";exit ;;
            * ) echo "Incorrect input. Cancelling execution";exit 1;;
        esac
    done
fi

# Write out all the values we gathered into a tfvars file so you don't
# have to enter the values manually
cat <<EOF > "${TFVARS_FILE}"
project_id="${PROJECT}"
region="${REGION}"
shared_vpc_name="${SHARED_VPC_NAME}"
shared_vpc_subnet_name="${SHARED_VPC_SUBNET_NAME}"
shared_vpc_project_id="${SHARED_VPC_PROJECT_ID}"
shared_vpc_ip_range_pods_name="${POD_IP_RANGE_NAME}"
shared_vpc_ip_range_services_name="${SERVICE_IP_RANGE_NAME}"
EOF


    read -p "a shared VPC named b already exists in host project b. If this is from a previous deployment of this template, please select yes(y) to continue or no(n) to cancel and correct the issue: " yn ; tput sgr0 
    case $yn in
        [Yy]* ) echo "the deployment will attempt to leverage the existing ";exit ;;
        [Nn]* ) echo "to resolve this conflict either delete the existing Shared VPC, choose a different project/VPC name or deploy to the existing Shared VPC";exit ;;
        * ) echo "Incorrect input. Cancelling execution";exit 1;;
