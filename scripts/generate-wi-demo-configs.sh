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
source "$ROOT/scripts/common.sh"

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

# Generate kubenernetes configs based on unique vars.
cat <<EOF > "${WORKLOAD_ID_DIR}/namespace.yaml"
apiVersion: v1
kind: Namespace
metadata:
  name: workload-id-demo
  annotations:
    cnrm.cloud.google.com/project-id: ${PROJECT}
EOF

cat <<EOF > "${WORKLOAD_ID_DIR}/storage.yaml"
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMServiceAccount
metadata:
  name: workload-id-demo-gsa
spec:
  displayName: workload-id-demo-sa
---
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  annotations:
    cnrm.cloud.google.com/force-destroy: "false"
  name: ${BUCKET_NAME}
  namespace: workload-id-demo
spec:
  bucketPolicyOnly: true
---
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: workload-id-demo-storage-policy
  namespace: workload-id-demo
spec:
  member: serviceAccount:workload-id-demo-gsa@${PROJECT}.iam.gserviceaccount.com
  role: roles/storage.objectAdmin
  resourceRef:
    apiVersion: storage.cnrm.cloud.google.com/v1beta1
    kind: StorageBucket
    external: ${BUCKET_NAME} 
EOF

cat <<EOF > "${WORKLOAD_ID_DIR}/sa.yaml"
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    iam.gke.io/gcp-service-account: workload-id-demo-gsa@${PROJECT}.iam.gserviceaccount.com
  name: workload-id-demo-ksa
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
    name: workload-id-demo-gsa
  bindings:
    - role: roles/iam.workloadIdentityUser 
      members: 
        - serviceAccount:${PROJECT}.svc.id.goog[workload-id-demo/workload-id-demo-ksa]
EOF

cat <<EOF > "${WORKLOAD_ID_DIR}/deploy.yaml"
apiVersion: v1
kind: Service
metadata:
  name: demo
  namespace: workload-id-demo
  annotations:
    cloud.google.com/neg: '{"ingress": true}'
spec:
  ports:
  - port: 8080
    targetPort: 8080
    name: http 
  selector:
    app: demo
  type: ClusterIP
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: demo
  name: gcs-wi-test
  namespace: workload-id-demo
spec:
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      containers:
      - env:
        - name: PORT
          value: "8080"
        - name: BUCKET_NAME
          value: ${BUCKET_NAME}
        image: gcr.io/cloud-build-github-trigger/github.com/knee-berts/example-go-gcp-storage-app:v0.1
        imagePullPolicy: Always
        name: gcs-fuse-workload
        ports:
          - name: http
            containerPort: 8080
        resources:
          limits:
            cpu: 500m
            memory: 512Mi
          requests:
            cpu: 250m
            memory: 50Mi
        readinessProbe:
          httpGet:
            path: /healthz
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 5
          timeoutSeconds: 1
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 5
          timeoutSeconds: 1
      serviceAccount: workload-id-demo-sa
      serviceAccountName: workload-id-demo-ksa
EOF

cat << EOF > "${WORKLOAD_ID_DIR}/bad-deploy.yaml"
apiVersion: v1
kind: Service
metadata:
  name: demo-bad
  namespace: workload-id-demo
  annotations:
    cloud.google.com/neg: '{"ingress": true}'
spec:
  ports:
  - port: 8080
    targetPort: 8080
    name: http 
  selector:
    app: demo-bad
  type: ClusterIP
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gcs-wi-test-bad
  namespace: workload-id-demo
spec:
  selector:
    matchLabels:
      app: demo-bad
  template:
    metadata:
      labels:
        app: demo-bad
    spec:
      containers:
      - env:
        - name: PORT
          value: "8080"
        - name: BUCKET_NAME
          value: ${BUCKET_NAME}
        image: gcr.io/cloud-build-github-trigger/github.com/knee-berts/example-go-gcp-storage-app:v0.1
        imagePullPolicy: Always
        name: gcs-fuse-workload
        ports:
          - name: http
            containerPort: 8080
        resources:
          limits:
            cpu: 500m
            memory: 512Mi
          requests:
            cpu: 250m
            memory: 50Mi
        readinessProbe:
          httpGet:
            path: /healthz
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 5
          timeoutSeconds: 1
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 5
          timeoutSeconds: 1
EOF

cat <<EOF > "${WORKLOAD_ID_DIR}/ingress.yaml"
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: workload-id-demo
  namespace: workload-id-demo
  annotations:
    kubernetes.io/ingress.class: "gce"
spec:
  rules:
  - host: good.example.com
    http:
      paths:
      - backend:
          serviceName: demo
          servicePort: 8080
  - host: bad.example.com
    http:
      paths:
      - backend:
          serviceName: demo-bad
          servicePort: 8080
EOF