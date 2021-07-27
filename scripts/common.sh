#!/bin/bash -e
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
# "-  Common commands for all scripts                      -"
# "-                                                       -"
# "---------------------------------------------------------"
set -o errexit
set -o pipefail

# Locate the root directory. Used by scripts that source this one.
# shellcheck disable=SC2034
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
SCRIPT_ROOT="${ROOT}/scripts"


# git is required for this tutorial
# https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
command -v git >/dev/null 2>&1 || { \
 echo >&2 "I require git but it's not installed.  Aborting."
 echo >&2 "Refer to: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git"
 exit 1
}

# glcoud is required for this tutorial
# https://cloud.google.com/sdk/install
command -v gcloud >/dev/null 2>&1 || { \
 echo >&2 "I require gcloud but it's not installed.  Aborting."
 echo >&2 "Refer to: https://cloud.google.com/sdk/install"
 exit 1
}

# Make sure kubectl is installed.  If not, refer to:
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
command -v kubectl >/dev/null 2>&1 || { \
 echo >&2 "I require kubectl but it's not installed.  Aborting."
 echo >&2 "Refer to: https://kubernetes.io/docs/tasks/tools/install-kubectl/"
 exit 1
}

# Simple test helpers that avoids eval and complex quoting. Note that stderr is
# redirected to stdout so we can properly handle output.
# Usage: test_des "description"
test_des() {
  echo -n "Checking that $1... "
}

# Usage: test_cmd "$(command string 2>&1)"
test_cmd() {
  local result=$?
  local output="$1"

  # If command completes successfully, output "pass" and continue.
  if [[ $result == 0 ]]; then
    	echo "pass"
  # If ccommand fails, output the error code, command output and exit.
  	else
			echo -e "fail ($result)\\n"
			cat <<<"$output"
			exit $result
  fi
}

if [ -f "${ROOT}/cluster_config" ]; then
    . "${ROOT}/cluster_config"
	else
		tput setaf 1; echo "" 1>&2
		read -p $'ERROR: Cannot load configuration information.Would you like to generate a new configuration?\n\nPlease enter yes(y) to generate a new configuration or no(n) to cancel initialization: ' yn ; tput sgr0 

		case $yn in
        [Yy]* ) tput setaf 3; echo "" 1>&2;
				echo $'INFO: Creating cluster configuration from template.  Please update the required variables and restart';
				cp "${SCRIPT_ROOT}/cluster_config.example" "${ROOT}/cluster_config" ;exit ;;
				[Nn]* ) tput setaf 2; echo "" 1>&2;
				echo $'WARN: Cancelling initialization, please verify your cluster_config file and restart';exit ;;
				* ) tput setaf 1; echo "" 1>&2;
				echo "ERROR: Incorrect input. Cancelling execution";exit 1;;
		esac
fi



# Obtain the needed env variables. Variables are only created if they are
# currently empty. This allows users to set environment variables if they
# would prefer to do so.
#
# The - in the initial variable check prevents the script from exiting due
# from attempting to use an unset variable.
if [[ -z "${REGION}" ]]; then
    echo $''1>&2
    exit 1;
fi

if [[ -z "${PROJECT}" ]]; then
    echo $''1>&2
    exit 1;
fi

if [[ -z "${ZONE}" ]]; then
    echo $''1>&2
    exit 1;
fi

if [[ -z "${GOVERNANCE_PROJECT}" ]]; then
    echo $''1>&2
    exit 1;
fi

# This check verifies if the PUBLIC_CLUSTER boolean value has been set to true
#  - If set to true, the cluster master endpoint is exposed as a public endpoint and the bastion host is not created
#  - If not set, the boolean value defaults to false and access to the the cluster master endpoint is limited to a bastion host
if [[ ${PUBLIC_CLUSTER} == true ]]; then
    PRIVATE="false"
    CLUSTER_TYPE="public"
    echo $'INFO: Creating Public cluster; access to the the cluster master endpoint will be unrestricted public endpoint' 1>&2
	else
    PRIVATE="true"
    CLUSTER_TYPE="private"
    echo $'INFO: Creating private cluster; access to the the cluster master endpoint will be limited to the bastion host' 1>&2
fi

if [[ -z ${AUTH_IP} ]] && [ "${PRIVATE}" = "true" ]; then
    tput setaf 1; echo "" 1>&2
    echo $'ERROR: Private Endpoint GKE Cluster access is restricted to a specified Public IP\n Please set \'AUTH_IP\''
    echo "" ; tput sgr0
    exit 1
fi

# This check verifies if the WINDOWS_CLUSTER boolean value has been set to true
#  - If set to true, a Windows GKE cluster is created
#  - If not set, the boolean value defaults to false and a linux GKE cluster is created
if [[ ${WINDOWS_CLUSTER} == true ]]; then
    WINDOWS="true"
    echo "INFO: Creating GKE Cluster with a Windows Node Pool" 1>&2
	else
    WINDOWS="false"
    echo "INFO: Creating GKE Cluster with a Linux Node Pool" 1>&2
fi

# This check verifies if the PREEMPTIBLE_NODES boolean value has been set to true
#  - If set to true, deploy GKE cluster with preemptible nodes
#  - If not set, the boolean value defaults to false and the cluster deploys with traditional node types
if [[ ${PREEMPTIBLE_NODES} == true ]]; then
    PREEMPTIBLE="true"
   echo "INFO: Creating GKE Cluster with with preemptible nodes" 1>&2
	else
    PREEMPTIBLE="false"
fi

# This check verifies if the SHARED_VPC boolean value has been set to true
#  - If set to true, additional variables are required to deployed to an existing shared VPC
#  - If not set, the boolean value defaults to false and GKE is deployed to an standalone VPC
if [[ ${SHARED_VPC} == true ]]; then
    echo "INFO: Verifying Shared VPC Configuration Information" 1>&2

    if [[ -z "${SHARED_VPC_NAME}" ]]; then
        tput setaf 1; echo "" 1>&2
        echo $'deploying to a shared VPC requires the shared VPC name to be set.' 1>&2
        echo "run 'export SHARED_VPC_NAME=<SHARED_VPC_NAME>'." 1>&2
        echo "replace <SHARED_VPC_NAME> with the shared VPC name." 1>&2
        echo "alternatively, changing the value of SHARED_VPC to false will create a standalone VPC in the service project where GKE is deployed." 1>&2
        echo "" ; tput sgr0
        exit 1;
    fi

    if [[ -z "${SHARED_VPC_SUBNET_NAME}" ]]; then
        tput setaf 1; echo "" 1>&2        
        echo "deploying to a shared VPC requires the shared VPC subnet name to be set." 1>&2
        echo "run 'export SHARED_VPC_SUBNET_NAME=<SHARED_VPC_SUBNET_NAME>'." 1>&2
        echo "replace <SHARED_VPC_SUBNET_NAME> with the subnet name in the shared VPC where GKE is to be deployed." 1>&2
        echo "alternatively, changing the value of SHARED_VPC to false will create a standalone VPC in the service project where GKE is deployed." 1>&2
        echo "" ; tput sgr0
        exit 1;
    fi

    if [[ -z "${SHARED_VPC_PROJECT_ID}" ]]; then
        tput setaf 1; echo "" 1>&2
        echo "deploying to a shared VPC requires the shared VPC project ID to be set." 1>&2
        echo "run 'export SHARED_VPC_PROJECT_ID=<SHARED_VPC_PROJECT_ID>'." 1>&2
        echo "replace <SHARED_VPC_PROJECT_ID> with shared VPC project ID." 1>&2
        echo "alternatively, changing the value of SHARED_VPC to false will create a standalone VPC in the service project where GKE is deployed." 1>&2
        echo "" ; tput sgr0
        exit 1;
    fi

    if [[ -z "${POD_IP_RANGE_NAME}" ]]; then
        tput setaf 1; echo "" 1>&2
        echo "deploying to a shared VPC requires a secondary IP range be created on the subnet and configured with the pod IP range for the cluster." 1>&2
        echo "run 'export POD_IP_RANGE_NAME=<POD_IP_RANGE_NAME>'." 1>&2
        echo "replace <POD_IP_RANGE_NAME> with the name of the secondary IP range created for pod IPs." 1>&2
        echo "alternatively, changing the value of SHARED_VPC to false will create a standalone VPC in the service project where GKE is deployed." 1>&2
        echo "" ; tput sgr0
        exit 1;
    fi

    if [[ -z "${SERVICE_IP_RANGE_NAME}" ]]; then
        tput setaf 1; echo "" 1>&2
        echo "deploying to a shared VPC requires a secondary IP range be created on the subnet and configured with the service IP range for the cluster." 1>&2
        echo "run 'export SERVICE_IP_RANGE_NAME=<SERVICE_IP_RANGE_NAME>'." 1>&2
        echo "replace <SERVICE_IP_RANGE_NAME> with the name of the secondary IP range created for service IPs." 1>&2
        echo "alternatively, changing the value of SHARED_VPC to false will create a standalone VPC in the service project where GKE is deployed." 1>&2
        echo "" ; tput sgr0
        exit 1;
    fi

    # Verify if the target shared VPC subnet exists and we have access to it - If not, fail the test
    #  - Perform same test for both the pod and service secondary subnets
    if [ "$(gcloud compute networks subnets describe $SHARED_VPC_SUBNET_NAME --region $REGION --project $SHARED_VPC_PROJECT_ID | grep name | sed 's/^.*: //')" != "$SHARED_VPC_SUBNET_NAME" ]; then
        tput setaf 1; echo "" 1>&2
        echo "shared VPC subnet ${SHARED_VPC_SUBNET_NAME} does not exist in region ${REGION} or you do not have access." 1>&2
        echo "please resolve this issue before continuing." 1>&2
        echo "" ; tput sgr0
        exit 1;
    elif [ "$(gcloud compute networks subnets describe $SHARED_VPC_SUBNET_NAME --region $REGION --project $SHARED_VPC_PROJECT_ID | grep $POD_IP_RANGE_NAME | sed 's/^.*: //')" != "$POD_IP_RANGE_NAME" ]; then
        tput setaf 1; echo "" 1>&2
        echo "secondary subnetwork ${POD_IP_RANGE_NAME} does not exist in shared VPC subnet ${SHARED_VPC_SUBNET_NAME} in region ${REGION} or you do not have access." 1>&2
        echo "please resolve this issue before continuing." 1>&2
        echo "" ; tput sgr0
        exit 1;
    elif [ "$(gcloud compute networks subnets describe $SHARED_VPC_SUBNET_NAME --region $REGION --project $SHARED_VPC_PROJECT_ID | grep $SERVICE_IP_RANGE_NAME | sed 's/^.*: //')" != "$SERVICE_IP_RANGE_NAME" ]; then
        tput setaf 1; echo "" 1>&2
        echo "secondary subnetwork ${SERVICE_IP_RANGE_NAME} does not exist in shared VPC subnet ${SHARED_VPC_SUBNET_NAME} in region ${REGION} or you do not have access." 1>&2
        echo "please resolve this issue before continuing." 1>&2
        echo "" ; tput sgr0
        exit 1;
    fi
	else 
    SHARED_VPC="false"
    echo "deploying GKE cluster in standalone VPC" 1>&2
fi

buildtype=$1

if [[ "${STATE}" = "gcs" ]]; then
  STATE="gcs"
	BUCKET="${PROJECT}-${buildtype}-state"
	echo -e "BUCKET=${BUCKET}" >> ${ROOT}/cluster_config
		
		case $buildtype in
			cluster) echo "" 1>&2;
				echo $'INFO: Creating backend configuration for Cluster Build';
				TERRAFORM_ROOT="${ROOT}/terraform/cluster_build";
				cat > ${TERRAFORM_ROOT}/backend.tf <<-'EOF'
					terraform {
					  backend "gcs" {
					  }
					}
				EOF
			;;

			vpc) echo "" 1>&2;
					echo $'INFO: Creating  backend configuration for Shared VPC Build';
					TERRAFORM_ROOT="${ROOT}/terraform/shared_vpc";
					cat > ${TERRAFORM_ROOT}/backend.tf <<- EOF 
					terraform {
					  backend "gcs" {
					  }
					}
					EOF
			;;

			security) echo "" 1>&2;
					echo $'INFO: Creating backend configuration for Cluster Security Build';
					TERRAFORM_ROOT="${ROOT}/terraform/security";
					cat > ${TERRAFORM_ROOT}/backend.tf <<- EOF  
					terraform {
					  backend "gcs" {
					  }
					}
					EOF
			;;

			*) tput setaf 1; echo "" 1>&2;
				echo "ERROR: Incorrect input. Cancelling execution";
				exit 1;;
			;;
		esac
	else
   STATE="local"
fi

case $buildtype in
		cluster) echo "" 1>&2;
				echo $'INFO: Creating terraform.tfvars file for Cluster Build';
				TERRAFORM_ROOT="${ROOT}/terraform/cluster_build";
				source "${SCRIPT_ROOT}/generate-tfvars.sh";
		;;

		vpc) echo "" 1>&2;
				echo $'INFO:  Creating terraform.tfvars for Shared VPC Build';
				TERRAFORM_ROOT="${ROOT}/terraform/shared_vpc";
				source "${SCRIPT_ROOT}/generate-tfvars.sh";
		;;

		security) echo "" 1>&2;
				echo $'INFO:  Creating terraform.tfvars for Cluster Security Build';
				TERRAFORM_ROOT="${ROOT}/terraform/security";
				source "${SCRIPT_ROOT}/generate-tfvars.sh";
		;;

		*) tput setaf 1; echo "" 1>&2;
			echo "ERROR: Incorrect input. Cancelling execution";
			exit 1;;
		;;
esac
