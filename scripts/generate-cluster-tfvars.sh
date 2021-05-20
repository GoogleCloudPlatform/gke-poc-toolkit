#!/usr/bin/env bash
# Copyright 2019 Google LLC
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

TFVARS_FILE="./terraform/cluster_build/terraform.tfvars"

# Obtain the needed env variables. Variables are only created if they are
# currently empty. This allows users to set environment variables if they
# would prefer to do so.
#
# The - in the initial variable check prevents the script from exiting due
# from attempting to use an unset variable.
[[ -z "${REGION-}" ]] && REGION="$(gcloud config get-value compute/region)"
if [[ -z "${REGION}" ]]; then
    echo "https://cloud.google.com/compute/docs/regions-zones/changing-default-zone-region" 1>&2
    echo "gcloud cli must be configured with a default region." 1>&2
    echo "run 'gcloud config set compute/region REGION'." 1>&2
    echo "replace 'REGION' with the region name like us-west1." 1>&2
    exit 1;
fi

[[ -z "${PROJECT-}" ]] && PROJECT="$(gcloud config get-value core/project)"
if [[ -z "${PROJECT}" ]]; then
    echo "gcloud cli must be configured with a default project." 1>&2
    echo "run 'gcloud config set core/project PROJECT'." 1>&2
    echo "replace 'PROJECT' with the project name." 1>&2
    exit 1;
fi

[[ -z "${ZONE-}" ]] && ZONE="$(gcloud config get-value compute/zone)"
if [[ -z "${ZONE}" ]]; then
    echo "https://cloud.google.com/compute/docs/regions-zones/changing-default-zone-region" 1>&2
    echo "gcloud cli must be configured with a default zone." 1>&2
    echo "run 'gcloud config set compute/zone ZONE'." 1>&2
    echo "replace 'ZONE' with the zone name like us-west1-a." 1>&2
    exit 1;
fi

[[ -z "${GOVERNANCE_PROJECT-}" ]] && GOVERNANCE_PROJECT="$(gcloud config get-value core/project)"
if [[ -z "${GOVERNANCE_PROJECT}" ]]; then
    echo "This script requires a project for governance resources." 1>&2
    echo "run 'export GOVERNANCE_PROJECT=PROJECT'." 1>&2
    echo "replace 'PROJECT' with the project name." 1>&2
    exit 1;
fi


if [ "${CLUSTER}" == private ]; then
    PRIVATE="true"
else
    PRIVATE="false"

fi

if [[ -z ${AUTH_IP} ]] && [ "${PRIVATE}" != "true" ]; then
    echo "Please set your public IP address"
    echo "run export AUTH_IP=IP"
    echo "replace IP with your IP"
fi


if [[ "${WINDOWS}" == true ]]; then
    WINDOWS="true"
else
    WINDOWS="false"

fi


if [[ "${PREEMPTIBLE}" == true ]]; then
    PREEMPTIBLE="true"
else
    PREEMPTIBLE="false"

fi

if [[ -z ${STATE} ]] && [ "${STATE}" != "gcs" ]; then
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
governance_project_id="${GOVERNANCE_PROJECT}"
region="${REGION}"
private_endpoint="${PRIVATE}"
cluster_name="$CLUSTER-endpoint-cluster"
network_name="$CLUSTER-cluster-network"
subnet_name="$CLUSTER-cluster-subnet"
zone = "${ZONE}"
auth_ip = "${AUTH_IP}"
windows_nodepool = "${WINDOWS}"
preemptible_nodes = "${PREEMPTIBLE}"
EOF
