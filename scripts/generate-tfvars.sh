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

TFVARS_FILE="${TERRAFORM_ROOT}/terraform.tfvars"


# If Terraform is run without this file, the user will be prompted for values.
# This check verifies if the file exists and prompts user for deletion
# We don't want to overwrite a pre-existing tfvars file
if [[ -f "${TFVARS_FILE}" ]]
then
    while true; do
        echo ""
         read -p "WARN: Found an existing terraform.tfvars indicating a previous execution. This file needs to be removed or renamed before rerunning the deployment. Select yes(y) to delete or no(n) to cancel execution: " yn ; tput sgr0 
        case $yn in
            [Yy]* ) echo "Deleting and recreating terraform.tfvars"; 
            rm ${TFVARS_FILE}; 
            break
            ;;
            [Nn]* ) echo "Cancelling execution";
            exit 1
            ;;
            * ) echo "Incorrect input. Cancelling execution";
            exit 1
            ;;
        esac
    done
fi

# Write out all the values we gathered into a tfvars file so you don't
# have to enter the values manually
cat <<-EOF > "${TFVARS_FILE}"
	project_id                        = "${PROJECT}"
	governance_project_id             = "${GOVERNANCE_PROJECT}"
	region                            = "${REGION}"
	private_endpoint                  = "${PRIVATE}"
	cluster_name                      = "${CLUSTER_TYPE}-endpoint-cluster"
	vpc_name                          = "${CLUSTER_TYPE}-cluster-network"
	subnet_name                       = "${CLUSTER_TYPE}-cluster-subnet"
	node_pool                         = "${CLUSTER_TYPE}-node-pool"
	zone                              = "${ZONE}"
	auth_ip                           = "${AUTH_IP}"
	windows_nodepool                  = "${WINDOWS}"
	preemptible_nodes                 = "${PREEMPTIBLE}"
	shared_vpc                        = "${SHARED_VPC}"
	shared_vpc_name                   = "${SHARED_VPC_NAME}"
	shared_vpc_subnet_name            = "${SHARED_VPC_SUBNET_NAME}"
	shared_vpc_project_id             = "${SHARED_VPC_PROJECT_ID}"
	shared_vpc_ip_range_pods_name     = "${POD_IP_RANGE_NAME}"
	shared_vpc_ip_range_services_name = "${SERVICE_IP_RANGE_NAME}"
EOF

