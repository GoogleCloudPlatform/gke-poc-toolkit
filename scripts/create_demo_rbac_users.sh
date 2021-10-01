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

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o pipefail

# Locate the root directory
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Collect the names and regions if the clusters created in the target project
declare -a GKE_CLUSTERS="$(terraform output --state=terraform/cluster_build/terraform.tfstate cluster_names | cut -d'[' -f 2 | cut -d']' -f 2 | cut -d'"' -f 2)"

# Define the cluster role bindings to create in each cluster - mapping = <service_account_name>:<cluster_role>
declare -a k8s_users=( 
            rbac-demo-auditor:view
            rbac-demo-editor:edit
            )

# Outer Loop - Loop through each cluster credential and authenticate to the cluster
for cluster in ${GKE_CLUSTERS}
do
    CREDENTIALS="$(terraform output --state=terraform/cluster_build/terraform.tfstate get_credential_commands | grep $cluster | cut -d'"' -f 2 | tr -d \")"
    $CREDENTIALS

    # Inner Loop - Create Cluster Role Bindings for demo k8s_users
    for k8s_user in "${k8s_users[@]}"
    do
        ROLE_NAME="${k8s_user%%:*}"
        ROLE_PERM="${k8s_user##*:}"
        PROJECT_ID="$(terraform output --state=terraform/cluster_build/terraform.tfstate project_id | tr -d \")"

cat <<EOF > new_role.yaml
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: $ROLE_NAME 
subjects:
- kind: User
  name: $ROLE_NAME@$PROJECT_ID.google.com.iam.gserviceaccount.com
roleRef:
  kind: ClusterRole
  name: $ROLE_PERM
  apiGroup: rbac.authorization.k8s.io
EOF

        kubectl apply -f new_role.yaml
    # End Inner Loop
    done
# End Outer Loop
done