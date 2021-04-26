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

# Obtain the needed env variables. Variables are only created if they are
# currently empty. This allows users to set environment variables if they
# would prefer to do so.
#
# The - in the initial variable check prevents the script from exiting due
# from attempting to use an unset variable.
[[ -z "${PROJECT-}" ]] && PROJECT="$(gcloud config get-value core/project)"
if [[ -z "${PROJECT}" ]]; then
    echo "gcloud cli must be configured with a default project." 1>&2
    echo "run 'gcloud config set core/project PROJECT'." 1>&2
    echo "replace 'PROJECT' with the project name." 1>&2
    exit 1;
fi

# Set variables for the demo folder kubernets config location.
WORKLOAD_ID_DIR="./demos/workload-identity"

# Generate a random name for the storage bucket used in the example app.
BUCKET_NAME="gke-application-bucket-$(openssl rand -hex 3)"

# Generate service account and storage account configs based on unique vars.
cat <<EOF > "${WORKLOAD_ID_DIR}/gcs-wi-test-sa.yaml"
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMServiceAccount
metadata:
  name: workload-id-demo-sa
spec:
  displayName: workload-id-demo-sa
  namespace: workload-id-demo
---
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    iam.gke.io/gcp-service-account: workload-id-demo-sa@${PROJECT}.iam.gserviceaccount.com
  name: workload-id-demo-sa
  namespace: workload-id-demo
---
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicy
metadata:
  name: workload-id-sa-policy
  namespace: workload-id-demo
spec:
  resourceRef:
    apiVersion:  iam.cnrm.cloud.google.com/v1beta1
    kind: IAMServiceAccount
    name: workload-id-demo-sa
  bindings:
    - role: roles/iam.workloadIdentityUser 
      members: 
        - serviceAccount:${PROJECT}.svc.id.goog[workload-id-demo/workload-id-demo-sa]
EOF

cat <<EOF > "${WORKLOAD_ID_DIR}/gcs-wi-test-storage.yaml"
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  annotations:
    cnrm.cloud.google.com/force-destroy: "false"
  name: ${BUCKET_NAME}
  namespace: workload-id-demo
spec:
  bucketPolicyOnly: true
  lifecycleRule:
    - action:
        type: Delete
      condition:
        age: 7
  versioning:
    enabled: true
---
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: storage-bucket-iam-member
spec:
  member: serviceAccount:workload-id-demo-sa@${PROJECT}.iam.gserviceaccount.com
  role: roles/storage.objectViewer 
  resourceRef:
    apiVersion: storage.cnrm.cloud.google.com/v1beta1
    kind: StorageBucket
    external: ${BUCKET_NAME?} 
EOF

cat <<EOF > "${WORKLOAD_ID_DIR}/gcs-wi-test-namespace.yaml"
apiVersion: v1
kind: Namespace
metadata:
  name: workload-id-demo
  annotations:
    cnrm.cloud.google.com/project-id: ${PROJECT}
EOF

# Create the demo app namespace then the rest of the k8s objects.
kubectl apply -f ${WORKLOAD_ID_DIR}/gcs-wi-test-namespace.yaml
kubectl apply -f ${WORKLOAD_ID_DIR}/.