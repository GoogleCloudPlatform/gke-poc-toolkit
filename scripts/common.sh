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

# Set input variable
buildtype=$1

# git is required for this tutorial
# https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
command -v git >/dev/null 2>&1 || { \
 echo >&2 "git require but it's not installed.  Aborting."
 echo >&2 "Refer to: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git"
 exit 1
}

# glcoud is required for this tutorial
# https://cloud.google.com/sdk/install
command -v gcloud >/dev/null 2>&1 || { \
 echo >&2 "gcloud required but it's not installed.  Aborting."
 echo >&2 "Refer to: https://cloud.google.com/sdk/install"
 exit 1
}

# Make sure kubectl is installed.  If not, refer to:
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
command -v kubectl >/dev/null 2>&1 || { \
 echo >&2 "kubectl required but it's not installed.  Aborting."
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
    echo $'INFO: Verifying GCP Configuration'

    # Verify the needed env variables. 
  if [[ -z "${REGION}" ]]; then
    tput setaf 1; echo "" 1>&2
    echo $'ERROR: This script requires Region information to deploy resources. Please update \'REGION\' with an appropriate region name, like \'us-west1\' in the \'cluster_config\' file' 1>&2
    echo $''1>&2; tput sgr0
    exit 1;
	fi

	if [[ -z "${ZONE}" ]]; then
    tput setaf 1; echo "" 1>&2
    echo $'ERROR: This script requires a Zone information to deploy resources. Please update \'ZONE\' with an appropriate zone name, like \'us-west1-a\' in the \'cluster_config\' file' 1>&2
    echo $''1>&2; tput sgr0
    exit 1;
	fi

	if [[ -z "${PROJECT}" ]]; then
    tput setaf 1; echo "" 1>&2
    echo $'ERROR: This script requires a project to deploy resources. Please update \'PROJECT\' with the project name in the \'cluster_config\' file' 1>&2
    echo $''1>&2; tput sgr0
    exit 1;
	fi

	if [[ -z "${GOVERNANCE_PROJECT}" ]]; then
    tput setaf 1; echo "" 1>&2
    echo $'ERROR: This script requires a project for governance resources. \nPlease update the \'GOVERNANCE_PROJECT\' in the \'cluster_config\' file' 1>&2
    echo $''1>&2; tput sgr0
    exit 1;
	fi

else
    tput setaf 7; echo "" 1>&2
    read -p $'INFO: A cluster_config file does not exist in the root of the directory indicating this is the first time this deployment has been run. \n\nIf this is a new deployment, please enter yes(y) to generate a new configuration file or no(n) to cancel initialization and troublshoot: ' yn ; tput sgr0 

    case $yn in
      [Yy]* ) tput setaf 2; echo "" 1>&2;
      echo $'A cluster_config file will now be created in the root directory. Please review the inputs and update as needed before restarting the deployment. If left unmodified, the default values will deploy a Private GKE cluster with a default linux nodepool in a standalone VPC.\n\nFor guidance on the cluster_config file and your deployment options, please reference:'; tput sgr0
      echo "https://github.com/GoogleCloudPlatform/gke-poc-toolkit/blob/main/docs/CLUSTERS.md"
      echo ""
      echo "INFO: The default cluster_config file leverages the Project, Region and Zone defaults in the current shell. Please verify these are set or enter new default values in cluster_config before proceeding."
      echo ""
      cp "${SCRIPT_ROOT}/cluster_config.example" "${ROOT}/cluster_config";
      exit
      ;;
      [Nn]* ) tput setaf 3; echo "" 1>&2;
      echo $'WARN: Cancelling initialization, please verify your cluster_config file and restart'; tput sgr0
      exit
      ;;
      * ) tput setaf 1; echo "" 1>&2;
      echo "ERROR: Incorrect input. Cancelling execution"; tput sgr0
      exit 1
      ;;
    esac
fi

# This check verifies if the PUBLIC_CLUSTER boolean value has been set to true
#  - If set to true, the cluster master endpoint is exposed as a public endpoint and the bastion host is not created
#  - If not set, the boolean value defaults to false and access to the the cluster master endpoint is limited to a bastion host
if [[ ${PUBLIC_CLUSTER} == true ]]; then
    PRIVATE="false"
    CLUSTER_TYPE="public"
    echo $'INFO: Setting deployment value to Public Cluster; access to the the cluster master endpoint will be unrestricted public endpoint' 1>&2
	else
    PRIVATE="true"
    CLUSTER_TYPE="private"
    echo $'INFO: Setting deployment value to Private Cluster; access to the the cluster master endpoint will be limited to the bastion host' 1>&2
fi

if [[ -z ${AUTH_IP} ]] && [ "${PRIVATE}" = "false" ]; then
  tput setaf 1; echo "" 1>&2
  echo $'ERROR: Public Endpoint GKE Cluster access will be restricted to a specified Public IP\n Please set \'AUTH_IP\''
  echo "" ; tput sgr0
  exit 1
fi

# This check verifies if the WINDOWS_CLUSTER boolean value has been set to true
#  - If set to true, a Windows GKE cluster is created
#  - If not set, the boolean value defaults to false and a linux GKE cluster is created
if [[ ${WINDOWS_CLUSTER} == true ]]; then
  WINDOWS="true"
  echo "INFO: Setting GKE Node Pool type to Windows" 1>&2
	else
  WINDOWS="false"
  echo "INFO: Setting GKE Node Pool type to Linux" 1>&2
fi

# This check verifies if the PREEMPTIBLE_NODES boolean value has been set to true
#  - If set to true, deploy GKE cluster with preemptible nodes
#  - If not set, the boolean value defaults to false and the cluster deploys with traditional node types
if [[ ${PREEMPTIBLE_NODES} == true ]]; then
  PREEMPTIBLE="true"
  echo "INFO: Setting GKE Node type to preemptible nodes" 1>&2
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
    echo $'ERROR: Deploying to a shared VPC requires the shared VPC name to be set.\n Please set \'SHARED_VPC_NAME\' in the \'cluster_config\' file'  1>&2
    echo "" ; tput sgr0
    exit 1;
  fi

  if [[ -z "${SHARED_VPC_SUBNET_NAME}" ]]; then
  	tput setaf 1; echo "" 1>&2  
		echo $'ERROR: Deploying to a shared VPC requires the shared VPC subnet name to be set.\n Please set \'SHARED_VPC_SUBNET_NAME\' in the \'cluster_config\' file'  1>&2      
    echo "" ; tput sgr0
    exit 1;
  fi

  if [[ -z "${SHARED_VPC_PROJECT_ID}" ]]; then
    tput setaf 1; echo "" 1>&2
		echo $'ERROR: Deploying to a shared VPC requires the Shared VPC Project ID to be set.\n Please set \'SHARED_VPC_PROJECT_ID\' in the \'cluster_config\' file'  1>&2    
    echo "" ; tput sgr0
    exit 1;
  fi

  if [[ -z "${POD_IP_RANGE_NAME}" ]]; then
    tput setaf 1; echo "" 1>&2
		echo $'ERROR: Deploying to a shared VPC requires requires a secondary IP range be created on the subnet and configured with the pod IP range for the cluster.\n Please set \'POD_IP_RANGE_NAME\' in the \'cluster_config\' file'  1>&2    
    echo "" ; tput sgr0
    exit 1;
  fi

  if [[ -z "${SERVICE_IP_RANGE_NAME}" ]]; then
    tput setaf 1; echo "" 1>&2
		echo $'ERROR: Deploying to a shared VPC requires requires a secondary IP range be created on the subnet and configured with the service IP range for the cluster.\n Please set \' SERVICE_IP_RANGE_NAME\' in the \'cluster_config\' file'  1>&2   
    echo "" ; tput sgr0
    exit 1;
  fi

	# Verify if the target shared VPC subnet exists and we have access to it - If not, fail the test
  #  - Skip this step if creating the Shared VPC (since it will not exist yet)
	#  - Perform same test for both the pod and service secondary subnets
  if [[ "${buildtype}" != "vpc" ]]; then
    if [ "$(gcloud compute networks subnets describe $SHARED_VPC_SUBNET_NAME --region $REGION --project $SHARED_VPC_PROJECT_ID | grep name | sed 's/^.*: //')" != "$SHARED_VPC_SUBNET_NAME" ]; then
      tput setaf 1; echo "" 1>&2
      echo "ERROR: Shared VPC subnet ${SHARED_VPC_SUBNET_NAME} does not exist in region ${REGION} or you do not have access." 1>&2
      echo "Please resolve this issue before continuing." 1>&2
      echo "" ; tput sgr0
      exit 1;
    elif [ "$(gcloud compute networks subnets describe $SHARED_VPC_SUBNET_NAME --region $REGION --project $SHARED_VPC_PROJECT_ID | grep $POD_IP_RANGE_NAME | sed 's/^.*: //')" != "$POD_IP_RANGE_NAME" ]; then
      tput setaf 1; echo "" 1>&2
      echo "ERROR: Secondary subnetwork ${POD_IP_RANGE_NAME} does not exist in shared VPC subnet ${SHARED_VPC_SUBNET_NAME} in region ${REGION} or you do not have access." 1>&2
      echo "Please resolve this issue before continuing." 1>&2
      echo "" ; tput sgr0
      exit 1;
    elif [ "$(gcloud compute networks subnets describe $SHARED_VPC_SUBNET_NAME --region $REGION --project $SHARED_VPC_PROJECT_ID | grep $SERVICE_IP_RANGE_NAME | sed 's/^.*: //')" != "$SERVICE_IP_RANGE_NAME" ]; then
      tput setaf 1; echo "" 1>&2
      echo "ERROR: Secondary subnetwork ${SERVICE_IP_RANGE_NAME} does not exist in shared VPC subnet ${SHARED_VPC_SUBNET_NAME} in region ${REGION} or you do not have access." 1>&2
      echo "Please resolve this issue before continuing." 1>&2
      echo "" ; tput sgr0
      exit 1;
    fi
  fi
else 
	SHARED_VPC="false"
	echo "INFO: Setting VPC type to standalone" 1>&2
fi

if [[ "${STATE}" = "gcs" ]]; then
  STATE="gcs"
	BUCKET="${PROJECT}-${buildtype}-state"
	echo -e "BUCKET=${BUCKET}" >> ${ROOT}/cluster_config
		
  case $buildtype in
    cluster) echo "" 1>&2;
    echo $'INFO: Setting values for backend configuration for Cluster Build';
    TERRAFORM_ROOT="${ROOT}/terraform/cluster_build";
    cat > ${TERRAFORM_ROOT}/backend.tf <<-'EOF'
    terraform {
      backend "gcs" {
      }
    }
		EOF
    ;;

    vpc) echo "" 1>&2;
    echo $'INFO: Setting values for backend configuration for Shared VPC Build';
    TERRAFORM_ROOT="${ROOT}/terraform/shared_vpc";
    cat > ${TERRAFORM_ROOT}/backend.tf <<-'EOF'
    terraform {
      backend "gcs" {
      }
    }
		EOF
    ;;

    secure) echo "" 1>&2;
    echo $'INFO: Setting values for backend configuration for Cluster Security Build';
    TERRAFORM_ROOT="${ROOT}/terraform/security";
    cat > ${TERRAFORM_ROOT}/backend.tf <<-'EOF'
    terraform {
      backend "gcs" {
      }
    }
		EOF
    ;;

    *) tput setaf 1; echo "" 1>&2;
    echo "ERROR: Incorrect input. Cancelling execution"; tput sgr0
    exit 1
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

  secure) echo "" 1>&2;
  echo $'INFO:  Creating terraform.tfvars for Cluster Security Build';
  TERRAFORM_ROOT="${ROOT}/terraform/security";
  source "${SCRIPT_ROOT}/generate-tfvars.sh";
  cat <<-EOF | kubectl apply -f -
  apiVersion: core.cnrm.cloud.google.com/v1beta1
  kind: ConfigConnector
  metadata:
    name: configconnector.core.cnrm.cloud.google.com
    spec:
      mode: cluster
      googleServiceAccount: "${CLUSTER_TYPE}-endpoint-cluster-kcc@${PROJECT}.iam.gserviceaccount.com" 
	EOF
  ;;

  *) tput setaf 1; echo "" 1>&2;
  echo "ERROR: Incorrect input. Cancelling execution"; tput sgr0
  exit 1
  ;;
esac


  if [ $buildtype != "vpc" ]; then
    echo "hi"
  fi