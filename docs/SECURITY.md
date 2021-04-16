# Security Considerations for GKE

## Before you Start

The provided scripts will populate the required  variables for the logging source from the region, zone, and project configurations of the default Google Cloud SDK profile. Ensure you are using the project that contains the previously created GKE clusters:

```shell
export REGION=<target compute region for gke>
export ZONE=<target compute zone for bastion host>
export PROJECT=<GCP Project>
```

An additional environment variable for the destination project is also required, this can be a seperate project or your existing project:

```shell
export LOG_PROJECT=<project-name>
```

## Securing the Cluster


### Audit Logging

Cloud Logging can be used aggregate logs from all GCP resources as well as any custom resources (on other platforms) to allow for one centralized store for all logs and metrics.  Logs are aggregated and then viewable within the provided Cloud Logging UI. They can also be [exported to Sinks](https://cloud.google.com/logging/docs/export/configure_export_v2) to support more specialized of use cases.  Currently, Cloud Logging supports exporting to the following sinks:

* Cloud Storage
* Pub/Sub
* BigQuery

The scripts in this repository will create a set of log sinks for collecting the Audit Logs of the GKE clusters; one targeting a Google Cloud Storage Bucket and one targeting a Big Query data set.  These sinks can be created in either a new centralized logging project or inside your existing GCP Project.

### Workload Identity

What is [Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)?

Workload identity is a way to securely provide access to Google cloud services within your Kubernetes cluster.

This is accomplished by binding a Google cloud service account, with the roles and/or permissions required to a Kubernetes Service account. An annotation on  the service account references the GCP service account which has the required roles and/or permissions to be able to access the Google cloud services within your cluster.

### Rolebased Access control

Role-based access control (RBAC) is a method of regulating access to computer or network resources based on the roles of individual users within your organization.

RBAC authorization uses the rbac.authorization.k8s.io API group to drive authorization decisions, allowing you to dynamically configure policies through the Kubernetes API.


### Network Policy


## Run Demo in a Google Cloud Shell

### Setup Cloud Shell Config and Deploy Security Features
Click the button below to run the demo in a [Google Cloud Shell](https://cloud.google.com/shell/docs/).

[![Open in Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/open?cloudshell_git_repo=https://github.com/GoogleCloudPlatform/gke-poc-toolkit.git&amp;cloudshell_image=gcr.io/graphite-cloud-shell-images/terraform:latest&amp;cloudshell_tutorial=SECURITY.md)

All the tools for the demo are installed. When using Cloud Shell execute the following
command in order to setup gcloud cli. When executing this command please setup your region
and zone.

```console
gcloud init
```

Deploy the security example:

```shell
# If running a public cluster simply run the following:
make secure CLUSTER=public

# If running a private master endpoint you need to set the proxy ahead of the make command like so:
HTTPS_PROXY=localhost:8888 make secure CLUSTER=private
```

### Audit Logs in Cloud Storage Validation

### Kubernetes + GCP RBAC Validation

Change the identity you are running gcloud under to the auditor service account and validate that change by observing the config list output.

```shell
gcloud auth activate-service-account --key-file ./creds/rbac-demo-auditor@$PROJECT.iam.gserviceaccount.com.json

gcloud config list
GKE_LOCATION=$(gcloud container clusters list --format="value(LOCATION)")
```
Retrieve a kubernetes config for the auditor service account and validate that you cannot get secrets.

```shell
GKE_NAME=$(gcloud container clusters list --format="value(NAME)")
gcloud container clusters get-credentials $GKE_NAME --region $GKE_LOCATION

kubectl auth can-i get secrets
# Don't forget to pipe in the proxy if you are using a private master endpoint
HTTPS_PROXY=localhost:8888 kubectl auth can-i get secrets
```

Now switch the gcloud identity to the editor service account and validate that change.

```shell
gcloud auth activate-service-account --key-file ./creds/rbac-demo-editor@$PROJECT.iam.gserviceaccount.com.json

gcloud config list
```
Retrieve a kubernetes config for the editor service account and validate that you now get secrets.

```shell
gcloud container clusters get-credentials $GKE_NAME --region $GKE_LOCATION

kubectl auth can-i get secrets
# Don't forget to pipe in the proxy if you are using a private master endpoint
HTTPS_PROXY=localhost:8888 kubectl auth can-i get secrets
```

## Workload ID validation

Get the external IP of the test application and POST against the endpoint a few times. You should see a 200 when you are routed to the pod that is using a workload identity with the correct RBAC on the storage account and a 403 when routed to the pod that hath not RBAC.

```shell
SERVICE_EXT_IP=$(kubectl get service -n storage-application gcs-wi-test-lb -o yaml | grep ip: | awk 'END{ print $3}')
while true ; do curl -X POST -d 'Some test data' http://$SERVICE_EXT_IP/test; sleep 1 ; done
```
