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

# Save current logged in admin user account
DEFAULT_ADMIN="$(gcloud config list account --format "value(core.account)")"

# Grab tfstate file from Google Cloud Storage account and store locally
BUCKET_NAME=$(cat ./terraform/cluster_build/backend.tf | grep bucket | sed 's/^.*= //' | tr -d '"')
gsutil cp gs://${BUCKET_NAME}/terraform/state/default.tfstate /tmp/temp.tfstate

# Collect the names and regions if the clusters created in the target project
declare -a GKE_CLUSTERS="$(terraform output --state=/tmp/temp.tfstate cluster_names | cut -d'[' -f 2 | cut -d']' -f 2 | cut -d'"' -f 2)"

# Define the cluster role bindings to create in each cluster - mapping = <service_account_name>:<cluster_role>
declare -a k8s_users=( 
            rbac-demo-auditor:view
            rbac-demo-editor:edit
            )

# Terminate any existing proxy connections before applying cluster role bindings
if [[ "$(pgrep -f L8888:127.0.0.1:8888)" ]]; then
    tput setaf 3; echo "Existing proxy tunnel detected - terminating before continuing" ; tput sgr0
    echo ""
    TUNNEL="$(pgrep -f L8888:127.0.0.1:8888)"
    kill $TUNNEL
fi

# Outer Loop - Loop through each cluster credential and authenticate to the cluster
for cluster in ${GKE_CLUSTERS}
do
    CREDENTIALS="$(terraform output --state=/tmp/temp.tfstate get_credential_commands | grep $cluster | cut -d'"' -f 2 | tr -d \")"
    tput setaf 3; echo "Creating sample cluster role bindings for cluster: $cluster"
    echo "Cluster credential command used to authenticate to cluster: $CREDENTIALS" ; tput sgr0
    $CREDENTIALS

    # Check if using internal-ip - If yes: proxy kubectl command through bastion host, if no: don't 
    if [[ $CREDENTIALS == *"internal-ip"* ]]; then

        # Check for proxy connection - Create if not exist if internal cluster detected
        echo "$cluster is a private cluster. Confirming SSH Bastion Tunnel/Proxy"
        if [[ ! "$(pgrep -f L8888:127.0.0.1:8888)" ]]; then
            echo "Did not detect a running SSH tunnel.  Opening a new one."
            BASTION_CMD="$(terraform output --state=/tmp/temp.tfstate bastion_ssh_command | tr -d \")"
            $BASTION_CMD -T -f tail -f /dev/null
        else
 		        echo "Detected a running SSH tunnel.  Skipping."
        fi
    else

        # Check for proxy connection - Disable if external cluster detected
        echo "$cluster is a public cluster. Disable SSH Bastion Tunnel/Proxy if detected"
        if [[ ! "$(pgrep -f L8888:127.0.0.1:8888)" ]]; then
          echo "Did not detect a running SSH tunnel. Skipping"
        else
          echo "Detected a running SSH tunnel, stopping tunnel"
          TUNNEL="$(pgrep -f L8888:127.0.0.1:8888)"
          kill $TUNNEL
        fi
    fi

    # Inner Loop - Create Cluster Role Bindings for demo k8s_users
    for k8s_user in "${k8s_users[@]}"
    do
        ROLE_NAME="${k8s_user%%:*}"
        ROLE_PERM="${k8s_user##*:}"
        PROJECT_ID="$(terraform output --state=/tmp/temp.tfstate project_id | tr -d \")"

cat <<EOF > new_role.yaml
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: $ROLE_NAME
subjects:
- kind: User
  name: $ROLE_NAME@$PROJECT_ID.iam.gserviceaccount.com
roleRef:
  kind: ClusterRole
  name: $ROLE_PERM
  apiGroup: rbac.authorization.k8s.io
EOF

        # Check if using internal-ip - If yes: proxy kubectl command through proxy, if no: don't 
        if [[ $CREDENTIALS == *"internal-ip"* ]]; then

            # Create the cluster role binding
            HTTPS_PROXY=localhost:8888 kubectl apply -f new_role.yaml

            # Authenticate as sample RBAC user and check for access to cluster secrets
            gcloud auth activate-service-account --key-file ./creds/$ROLE_NAME@$PROJECT_ID.iam.gserviceaccount.com.json
            $CREDENTIALS

            if [[ "$(HTTPS_PROXY=localhost:8888 kubectl auth can-i get secrets)" == *"yes"* ]]; then
                tput setaf 3; echo "Service Account: $ROLE_NAME@$PROJECT_ID.iam.gserviceaccount.com can access kubernetes secrets for cluster: $cluster" ; tput sgr0
            else 
                tput setaf 3; echo "Service Account: $ROLE_NAME@$PROJECT_ID.iam.gserviceaccount.com does NOT have access to kubernetes secrets for cluster: $cluster" ; tput sgr0            
            fi

            # Return to default session auth
            gcloud auth login $DEFAULT_ADMIN --brief --verbosity=none
            $CREDENTIALS
        else 

            # Create the cluster role binding
            kubectl apply -f new_role.yaml

            # Authenticate as sample RBAC user and check for access to cluster secrets
            gcloud auth activate-service-account --key-file ./creds/$ROLE_NAME@$PROJECT_ID.iam.gserviceaccount.com.json
            $CREDENTIALS

            if [[ "$(kubectl auth can-i get secrets)" == *"yes"* ]]; then
                tput setaf 3; echo "Service Account: $ROLE_NAME@$PROJECT_ID.iam.gserviceaccount.com can access kubernetes secrets for cluster: $cluster" ; tput sgr0
            else 
                tput setaf 3; echo "Service Account: $ROLE_NAME@$PROJECT_ID.iam.gserviceaccount.com does NOT have access to kubernetes secrets for cluster: $cluster" ; tput sgr0            
            fi

            # Return to default session auth
            gcloud auth login $DEFAULT_ADMIN --brief --verbosity=none
            $CREDENTIALS
        fi

    # End Inner Loop
    done
# End Outer Loop
done

if [[ "$(pgrep -f L8888:127.0.0.1:8888)" ]]; then
    tput setaf 3; echo "Private cluster detected - Proxy to bastion host will be left in place" ; tput sgr0
fi
