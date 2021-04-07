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
  echo "Did not detect a running SSH tunnel. Skipping"
else
  echo "Detected a running SSH tunnel, stopping tunnel."
  TUNNEL="$(pgrep -f L8888:127.0.0.1:8888)"
  kill $TUNNEL
fi