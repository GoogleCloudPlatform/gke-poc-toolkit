# Security Considerations for GKE

## Before you Start

The provided scripts will populate the required  variables for the logging source from the region, zone, and project configurations of the default Google Cloud SDK profile. Ensure you are using the project that contains the previously created GKE clusters:

```shell
#These should match the settings in the cluster build step
export REGION=<target compute region for gke>
export ZONE=<target compute zone for bastion host>
export PROJECT=<GCP Project>
export GOVERNANCE_PROJECT=<project-name>
```

## What Gets Enabled

#### Audit Logging

Cloud Logging can be used aggregate logs from all GCP resources as well as any custom resources (on other platforms) to allow for one centralized store for all logs and metrics.  Logs are aggregated and then viewable within the provided Cloud Logging UI. They can also be [exported to Sinks](https://cloud.google.com/logging/docs/export/configure_export_v2) to support more specialized of use cases.  Currently, Cloud Logging supports exporting to the following sinks:

* Cloud Storage
* Pub/Sub
* BigQuery

The scripts in this repository will create a set of log sinks for collecting the Audit Logs of the GKE clusters; one targeting a Google Cloud Storage Bucket and one targeting a Big Query data set.  These sinks can be created in either a new centralized logging project or inside your existing GCP Project. Please reference [this link](https://cloud.google.com/logging/docs/export) for a conceptual overview of log exports and how sinks work. 

#### Rolebased Access control

Role-based access control (RBAC) is a method of regulating access to computer or network resources based on the roles of individual users within your organization.

RBAC authorization uses the rbac.authorization.k8s.io API group to drive authorization decisions, allowing you to dynamically configure policies through the Kubernetes API.

The scripts in this repository will create two sample Google Cloud Identities, `rbac-demo-auditor` and `rbac-demo-editor`, that have kubernetes 'view' and 'edit' ClusterRoles respectively. After creation, a simple test is provided to demonstrate the scope of permissions. These roles are intended to represent the a sample audit and administrative user. 


#### Network Policy

Roadmap Item


## Securing the Cluster

Execute the following steps to apply the hardening config to the cluster:

```shell
# If running a public cluster simply run the following:
make secure CLUSTER=public

# If running a private master endpoint, validate the proxy is started. Then set the 
# HTTPS_PROXY environment variable to forward the make command through the tunnel:
make start-proxy

HTTPS_PROXY=localhost:8888 make secure CLUSTER=private
```

#### Audit Logs in Cloud Storage Validation

To view Log Router sinks created by this deployment in the GCP Portal UI navigated to Logging -> Logs Router in the Cluster Project. 

To view the Big Query Data Set created by this deployment in the GCP Portal UI, nagivate to BigQuery -> SQL Workspace and view the dataset for the Governance Project.

#### Kubernetes + GCP RBAC Validation

Change the identity you are running gcloud under to the auditor service account and validate that change by observing the config list output.

```shell
gcloud auth activate-service-account --key-file ./creds/rbac-demo-auditor@$PROJECT.iam.gserviceaccount.com.json

gcloud config list
```
Retrieve a kubernetes config for the auditor service account and validate that you cannot get secrets.

```shell
GKE_NAME=$(gcloud container clusters list --format="value(NAME)")
GKE_LOCATION=$(gcloud container clusters list --format="value(LOCATION)")

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

#### Next steps

The next step is to deploy a secure workload to the cluster.

[Deploy Secure GKE Workloads (Linux Cluster Only)](WORKLOADS.md)

#### Check the [FAQ](FAQ.md) if you run into issues with the build.
