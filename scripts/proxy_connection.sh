#!/usr/bin/env bash

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

echo "Detecting SSH Bastion Tunnel/Proxy"
if [[ ! "$(pgrep -f L8888:127.0.0.1:8888)" ]]; then
  echo "Did not detect a running SSH tunnel.  Opening a new one."
  # shellcheck disable=SC2091
  BASTION_CMD="$(terraform output --state=terraform/cluster_build/terraform.tfstate bastion_ssh_command)"
  $BASTION_CMD -f tail -f /dev/null
 
  CREDENTIALS="$(terraform output --state=terraform/cluster_build/terraform.tfstate get_credentials_command)"
  KUBECTL="$(terraform output --state=terraform/cluster_build/terraform.tfstate bastion_kubectl_command)"
  echo "SSH Tunnel/Proxy is now running.
  Generate cluster credentials with gcloud:
   $CREDENTIALS
   
  Connect to the cluster with kubectl:  
   $KUBECTL"
else
  echo "Detected a running SSH tunnel.  Skipping."
fi
