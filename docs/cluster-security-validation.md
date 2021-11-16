# Cluster Security Validation 

* [Audit Logs in Cloud Storage Validation](#audit-logs-in-cloud-storage-validation)
* [Kubernetes + GCP RBAC Validation](#kubernetes-and-gcp-rbac-validation)

## Audit Logs in Cloud Storage Validation

To view Log Router sinks created by this deployment in the GCP Portal UI navigated to Logging -> Logs Router in the Cluster Project. 

To view the Big Query Data Set created by this deployment in the GCP Portal UI, nagivate to BigQuery -> SQL Workspace and view the dataset for the Governance Project.

## Kubernetes and GCP RBAC Validation

#### Create and validate demo RBAC users

Run [./scripts/create_and_validate_demo_rbac_users.sh](../scripts/create_and_validate_demo_rbac_users.sh) from the root directory to create a demo auditor and editor RBAC user in each cluster. Once created, the script also validates the permissions of these accounts in each cluster. 

#### Manually validate demo RBAC users

To manually validate the RBAC users created against a specific cluster, follow the steps below. 

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