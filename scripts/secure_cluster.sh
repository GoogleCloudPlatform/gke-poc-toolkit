#!/usr/bin/env bash

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o pipefail

# Locate the root directory
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# shellcheck source=scripts/common.sh
source "${ROOT}/scripts/common.sh"

# Generate the variables to be used by Terraform
# shellcheck source=scripts/generate-tfvars.sh
# TODO remove this
source "${ROOT}/scripts/generate-security-tfvars.sh"

# Initialize and run Terraform
(cd "${ROOT}/terraform/security"; terraform init -input=false)
(cd "${ROOT}/terraform/security"; terraform apply -input=false -auto-approve)

