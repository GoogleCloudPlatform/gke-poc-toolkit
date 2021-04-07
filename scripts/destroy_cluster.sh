#!/usr/bin/env bash


# Do not set errexit as it makes partial deletes impossible
set -o nounset
set -o pipefail

# Locate the root directory
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# shellcheck source=scripts/common.sh
source "$ROOT/scripts/common.sh"

# Tear down Terraform-managed resources and remove generated tfvars
cd "$ROOT/terraform/cluster_build" || exit;

# Perform the destroy
terraform destroy -input=false -auto-approve

# Remove the tfvars file generated during "make create"
rm -f "$ROOT/terraform/cluster_build/terraform.tfvars"
rm -f "$ROOT/terraform/cluster_build/terraform.tfstate"
