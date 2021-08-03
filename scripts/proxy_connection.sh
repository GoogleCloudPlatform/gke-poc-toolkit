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

start_proxy() {
		
	echo "Detecting SSH Bastion Tunnel/Proxy"
	if [[ ! "$(pgrep -f L8888:127.0.0.1:8888)" ]]; then
		echo "Did not detect a running SSH tunnel.  Opening a new one."
		BASTION_CMD="$(terraform output --state=terraform/cluster_build/terraform.tfstate bastion_ssh_command | tr -d \")"
		$BASTION_CMD -f tail -f /dev/null
	
		CREDENTIALS="$(terraform output --state=terraform/cluster_build/terraform.tfstate get_credentials_command | tr -d \")"
		KUBECTL="$(terraform output --state=terraform/cluster_build/terraform.tfstate bastion_kubectl_command | tr -d \")"
		tput setaf 2; echo "SSH Tunnel/Proxy is now running.
		Generate cluster credentials with gcloud:
		$CREDENTIALS
		
		Connect to the cluster with kubectl:  
		$KUBECTL"; tput sgr0
	else
		echo "Detected a running SSH tunnel.  Skipping."
	fi
}

stop_proxy() {

	echo "Detecting SSH Bastion Tunnel/Proxy"
	if [[ ! "$(pgrep -f L8888:127.0.0.1:8888)" ]]; then
		echo "Did not detect a running SSH tunnel. Skipping"
	else
		echo "Detected a running SSH tunnel, stopping tunnel."
		TUNNEL="$(pgrep -f L8888:127.0.0.1:8888)"
		kill $TUNNEL
	fi
}
flag=$1
case ${flag} in

	start ) start_proxy
	;;
	stop ) stop_proxy
	;;

esac