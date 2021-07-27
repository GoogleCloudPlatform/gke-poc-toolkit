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

# Configure the connfig connector with the project GKE was created in. 
# This is done in the hardening build already but I want to ensure this demo
# can run standalone. 

start_demo() {
	# Get KCC SA email
	KCC_SA_EMAIL=$(gcloud iam service-accounts list | grep cluster-kcc | awk 'END{ print $4}')

	cat <<-EOF | kubectl apply -f -
	apiVersion: core.cnrm.cloud.google.com/v1beta1
	kind: ConfigConnector
	metadata:
	  name: configconnector.core.cnrm.cloud.google.com
	spec:
	  mode: cluster
	  googleServiceAccount: "${KCC_SA_EMAIL}" 
	EOF

	# Generate the demo kubernetes configs 
	source "${ROOT}/scripts/generate-wi-demo-configs.sh"

	# Set variables for the demo folder kubernetes config location.
	WORKLOAD_ID_DIR="./demos/workload-identity"

	# Create the demo app namespace then the rest of the k8s objects.
	kubectl apply -f ${WORKLOAD_ID_DIR}/namespace.yaml
	kubectl apply -f ${WORKLOAD_ID_DIR}/storage.yaml -n workload-id-demo
	kubectl apply -f ${WORKLOAD_ID_DIR}/sa.yaml
	kubectl apply -f ${WORKLOAD_ID_DIR}/deploy.yaml
	kubectl apply -f ${WORKLOAD_ID_DIR}/bad-deploy.yaml
	kubectl apply -f ${WORKLOAD_ID_DIR}/ingress.yaml
}

stop_demo() {

	# Set variables for the demo folder kubernetes config location.
	WORKLOAD_ID_DIR="./demos/workload-identity"

	# Delete the kubernetes resources.
	echo "Deleting all of the KCC and native k8s resources, be patient this can take a minute or two."
	kubectl delete -f ${WORKLOAD_ID_DIR}/. -n workload-id-demo 
}

flag=$1
case ${flag} in

	start ) start_demo
	;;
	stop ) stop_demo
	;;

esac