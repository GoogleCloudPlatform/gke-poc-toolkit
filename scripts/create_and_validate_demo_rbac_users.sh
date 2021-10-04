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
    tput setaf 3; echo "Creating sample cluster role bindings for cluster: $cluster"
    echo "Cluster credential command used to authenticate to cluster: $CREDENTIALS" ; tput sgr0
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

        # Check if using internal-ip - If yes: proxy kubectl command through proxy, if no: don't 
        if [[ $CREDENTIALS == *"internal-ip"* ]]; then

            # Check for proxy connection if internal IP - Create if not detected 
            echo "Private cluster detected. Confirming SSH Bastion Tunnel/Proxy"
            if [[ ! "$(pgrep -f L8888:127.0.0.1:8888)" ]]; then
              echo "Did not detect a running SSH tunnel.  Opening a new one."
              BASTION_CMD="$(terraform output --state=terraform/cluster_build/terraform.tfstate bastion_ssh_command | tr -d \")"
              $BASTION_CMD -T -f tail -f /dev/null
            else
              echo "Detected a running SSH tunnel.  Skipping."
            fi

            # Create the cluster role binding
            HTTPS_PROXY=localhost:8888 kubectl apply -f new_role.yaml

            # Authenticate as sample RBAC user and check for access to cluster secrets
            gcloud auth activate-service-account --key-file ./creds/$ROLE_NAME@$PROJECT_ID.iam.gserviceaccount.com.json
            CAN_ACCCESS_SECRET="$(HTTPS_PROXY=localhost:8888 kubectl auth can-i get secrets)"

        else 
            # Create the cluster role binding
            kubectl apply -f new_role.yaml

            # Authenticate as sample RBAC user and check for access to cluster secrets
            gcloud auth activate-service-account --key-file ./creds/$ROLE_NAME@$PROJECT_ID.iam.gserviceaccount.com.json
            CAN_ACCCESS_SECRET="$(kubectl auth can-i get secrets)"
        fi
        
        # Output secret check result      
        if [[ $CAN_ACCESS_SECRET == *"yes"* ]]; then
          tput setaf 3; echo "Service Account: $ROLE_NAME@$PROJECT_ID.iam.gserviceaccount.com can access kubernetes secrets for cluster: $cluster" ; tput sgr0
        else
          tput setaf 3; echo "Service Account: $ROLE_NAME@$PROJECT_ID.iam.gserviceaccount.com can NOT access kubernetes secrets for cluster: $cluster" ; tput sgr0
        fi

        # Revoke service account auth and return to default session auth
        gcloud auth revoke $ROLE_NAME@$PROJECT_ID.iam.gserviceaccount.com

    # End Inner Loop
    done
# End Outer Loop
done