# GKE Cluster Deployments

* [Before you begin](#before-you-begin)
* [Deploying the GKE cluster](#deploying-the-gke-cluster)
* [Validate GKE cluster config](#validate-gke-cluster-config)
* [Next steps](#next-steps)
* [Cleaning up](#cleaning-up)

## Before you begin

The scripts provided in this repository require the existence of a `cluster_config` file in the root directory. This config file contains a baseline set of information, including the GCP Region, Zone and Project to be used when creating the GKE cluster. A template configuration file can be found [here](./scripts/cluster_config.example).

The section below outlines the required and optional configuration settings, including default values

## GKE Cluster Creation Values

Default values for required information have be populated to use the current configuration of the Google Cloud SDK, during cluster deployment. If you need to deploy the GKE cluster in a region,zone or project that is different than your current Google Cloud SDK configuration information, update the following settings in the `cluster_config` file

### Required Settings

| Setting | Description| Default Value|
|:-|:-|:-| 
|REGION |Target compute region for GKE|`gcloud config get-value compute/region` |
|ZONE| Target compute zone for bastion host| `gcloud config get-value compute/zone`|
|PROJECT| GCP Project to use| `gcloud config get-value project`|

### Optional Settings

Included in the `cluster_config` configuration file are options for Shared VPC configurations, GKE Cluster Node Pools with Windows nodes,  pre-emptible node configurations, and GKE control plane access configurations. In the sections below, the available optional settings and their default values are described. Update the `cluster_config` file as needed to use these additional features


**Log Sinks**

The default deployment reuses the GCP project configred to host resources such as the KVM and log sinks. As a best practice it is recommended that a separate project is used, however the default value can be used for testing purposes

| Setting | Description| Default Value|
|:-|:-|:-|
|GOVERNANCE_PROJECT| GCP Project used for KVM, Log Sinks and Governance|`gcloud config get-value project`|

**[Public Endpoint Cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks)** 

The default deployment limits GKE control plane access to the bastion host subnet in the GKE VPC. Enabling the following configuration setting will grant control plane access to the public endpoint of the deployment device. The bastion host will not be deployed if this option is selected. If you choose this deployment option, please use [Deploy a GKE Cluster with Public endpoint](#deploy-a-gke-cluster-with-public-endpoint) for deployment next steps. 

| Setting | Description| Default Value|
|:-|:-|:-|
PUBLIC_CLUSTER||false|

**[Windows Node Pool](https://cloud.google.com/kubernetes-engine/docs/concepts/windows-server-gke)**

The default deployment limits the GKE cluster deploys a linux node pool. Enabling the following configuration setting will deploy an additional Windows node pool for deploying Windows Server container workloads. 

| setting | Description| Default Value|
|:-|:-|:-|
WINDOWS_CLUSTER||false|

**[Preemptible Nodes](https://cloud.google.com/kubernetes-engine/docs/how-to/preemptible-vms)** 

The default deployment limits the GKE cluster to non-preemptible nodes which cannot be reclaimed while in use. Enabling the following configuration setting will deploy the cluster with preemptible nodes that last a maximum of 24 hours and provide no availability guarentees.

| setting | Description| Default Value|
|:-|:-|:-|
PREEMPTIBLE_NODES||false|

**[Shared VPC](https://cloud.google.com/vpc/docs/shared-vpc)**

The default deployment deploys to a standalone VPC in the project where the cluster is created. Enabling the following configuration settings will deploy the GKE cluster to a shared VPC in a Host Project of your choice.

>**NOTE:** Deploying multiple GKE Toolkit environments to the same shared VPC is not currently supported. This feature will be added in the future. 

**The following pre-requisites must be completed prior to running the deployment**

* A Shared VPC in a Host Project must be created before executing this step. That VPC must meet the following prerequisites:
  * Two secondary IP ranges must be created on the target shared VPC subnet and configured with the pod and service IP CIDR ranges.
    * Example:
      * pod-ip-range       10.1.64.0/18
      * service-ip-range   10.2.64.0/18
  * The Service Project must be attached to the Shared VPC and the target subnet must be shared and in the deployment region. 
  * Kubernetes Engine Access must be enabled on the shared subnet.

| Setting | Description| Default Value|
|:-|:-|:-| 
|SHARED_VPC||false|
|SHARED_VPC_PROJECT_ID|shared VPC project ID||
|SHARED_VPC_NAME|The Shared VPC name||
|SHARED_VPC_SUBNET_NAME|The name of the shared VPC subnet name||
|POD_IP_RANGE_NAME|The name of the secondary IP range used for cluster pod IPs||
|SERVICE_IP_RANGE_NAME|The name of the secondary IP range used for cluster services||


## Deploying the GKE cluster

### Deploy a GKE Cluster with Private Endpoint

This cluster features both private nodes and a private control plane node.

The code in the `scripts` directory generates and populates terraform variable information and creates the following resources in the region, zone, and project specified:

* GKE Cluster with Private Endpoint
  * Workload Identity enabled 
  * A least privileged Google Service Account assigned to compute engine instances
  * Master Authorized Networks enabled - Allows traffic from specified IP addresses to the GKE Control plane
  * Application layer secrets
  * Kubernetes Config Connector enabled

* VPC Networks
  * subnets
  * firewall rules
  * Cloud NAT - provide outbound internet access for the clusters
  * Cloud Routers

* Cloud KMS
  * key ring for storing the application layer secret KEK

* Compute Engine instance - acts as a bastion host, mapped to the GKE Cluster's Master Authorized Network

In the root of this repository, there is a script to create the cluster:

```shell
make create
```

Once the GKE cluster has been created, establish an SSH tunnel to the bastion:

```shell
make start-proxy
```

Retrieve the kubernetes config for the cluster, then set the `HTTPS_PROXY` environment variable to validate you can forward kubectl commands through the tunnel:

```shell
GKE_NAME=$(gcloud container clusters list --format="value(NAME)")
GKE_LOCATION=$(gcloud container clusters list --format="value(LOCATION)")

gcloud container clusters get-credentials $GKE_NAME --region $GKE_LOCATION

HTTPS_PROXY=localhost:8888 kubectl get ns
```

Stopping the SSH Tunnel:

```shell
make stop-proxy
```

Proceed to [validation steps](#kubernetes-app-layer-secrets-validation) once installation completes. 

### Deploy a GKE Cluster with Public endpoint

This cluster features cluster nodes with private IP's and a control plane api with a public IP.

The code in the `scripts` directory generates and populates terraform variable information and creates all the same resources as the private endpoint cluster with the exception of the bastion host, which is not created. 

The `AUTH_IP` configuration setting contains an example command to extract and store the external IP of the system running the script. Update this setting to the external IP for Public IP of the  client you plan to use

In the root of this repository, there is a script to create the cluster:

```shell
# Create cluster
make create
```

## Validate GKE cluster config

### Kubernetes App Layer Secrets Validation

Execute the following command to retrieve the kubernetes config for the cluster if not collected in the previous step:

```shell
GKE_NAME=$(gcloud container clusters list --format="value(NAME)")
GKE_LOCATION=$(gcloud container clusters list --format="value(LOCATION)")

gcloud container clusters get-credentials $GKE_NAME --region $GKE_LOCATION
```

The following command validates that Application-layer Secrets Encryption is enabled. If the cluster is using app secrets, the response contains an EncryptionConfig of `ENCRYPTED`:

```shell
gcloud container clusters describe $GKE_NAME \
  --region $GKE_LOCATION \
  --format 'value(databaseEncryption)' \
  --project $PROJECT

```



### GKE Cluster with Windows Nodepool Validation (If Windows Node Pools were selected)

Execute the following command to retrieve the kubernetes config for the cluster:

```shell
GKE_NAME=$(gcloud container clusters list --format="value(NAME)")
GKE_LOCATION=$(gcloud container clusters list --format="value(LOCATION)")

gcloud container clusters get-credentials $GKE_NAME --region $GKE_LOCATION
```

Validate Windows Server Node pool has been created:

```shell
kubectl get nodes --label-columns beta.kubernetes.io/os
```

## Next steps

The next step is to futher harden the newly created cluster.

[GKE Hardening Instructions](SECURITY.md)

### Check the [FAQ](FAQ.md) if you run into issues with the build.

## Cleaning up

Running the command below will destroy all resources with the exception of the Cloud KMS, Key Rings and Keys created by this deployment. Futher deployments will create a new key ring and keys for use by the cluster. This is due to a feature in Cloud KMS requiring a [24 hour scheduled deletion of keys](https://cloud.google.com/kms/docs/faq#cannot_delete). Because of this, it is recommended to manually schedule the deletion of key rings and keys created while testing this deployment. 

```shell
make destroy

```

NOTE: Cloud KMS resources are removed from terraform state resulting in the following error when executing a `terraform destroy`. This error can be safely ignored: 

<img src="../assets/invalid-function-on-destroy.png" alt="invalid-function-on-destroy" width="900"/>
