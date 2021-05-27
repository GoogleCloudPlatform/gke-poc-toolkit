# GKE Cluster Deployments

* [Before you begin](#before-you-begin)
* [Configure the GKE cluster](#configure-the-gke-cluster)
* [Validate GKE cluster config](#validate-gke-cluster-config)
* [Next steps](#next-steps)
* [Cleaning up](#cleaning-up)

## Before you begin

#### Required Variables
The provided scripts will populate the required variables from the region, zone, and project envars.

```shell
export REGION=<target compute region for gke>
export ZONE=<target compute zone for bastion host>
export PROJECT=<GCP Project>
```

An additional environment variable for the governance project is also required. This project will be used to host resources such as the KVM and log sinks. As a best practice it is recommended that a separate project is used, however, the existing project can be used for testing purposes:

```shell
export GOVERNANCE_PROJECT=<project-name>
```

#### Optional Variables

[Public Endpoint Cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks) - The default deployment limits GKE control plane access to the bastion host subnet in the GKE VPC. Setting the following environment variable will grant control plane access to the public endpoint of the deployment device. The bastion host will not be deployed if this option is selected. If you choose this deployment option, please use [Configure GKE Cluster with Public endpoint](#configure-gke-cluster-with-public-endpoint) for deployment next steps. 

```shell
export PUBLIC_CLUSTER=true
```

[Windows Node Pool](https://cloud.google.com/kubernetes-engine/docs/concepts/windows-server-gke) - By default the GKE cluster deploys a linux node pool. Setting the following environment variable will deploy an additional Windows node pool for deploying Windows Server container workloads. 

```shell
export WINDOWS_CLUSTER=true
```

[Preemptible Nodes](https://cloud.google.com/kubernetes-engine/docs/how-to/preemptible-vms) - By default the GKE cluster non-preemptible nodes which cannot be reclaimed while in use. Setting the following environment variable will deploy the cluster with preemptible nodes that last a maximum of 24 hours and provide no availability guarentees.

```shell
export PREEMPTIBLE_NODES=true
```

[Shared VPC](https://cloud.google.com/vpc/docs/shared-vpc) - By default the GKE cluster deploys to a standalone VPC in the project where the cluster is created. Setting the following environment variables will deploy the GKE cluster to a shared VPC in a Host Project of your choice.

<b>NOTE:</b> Deploying multiple GKE Toolkit environments to the same shared VPC is not currently supported. This feature will be added in the future. 

```shell
# The following prerequisites must be completed prior to running the deployment:
# 
#  - A shared VPC in a host project must be created before executing this step. That VPC should follow the guidance below. 
# 
#  - The account used to perform this deployment must have Shared VPC Admin permissions to the shared VPC host project.
#
#  - Two secondary IP ranges must be created on the target shared VPC subnet and configured with the pod and service 
#    IP CIDR ranges. Examples below: 
#     - pod-ip-range       10.1.64.0/18
#     - service-ip-range   10.2.64.0/18

# All variables are required in order to deploy to a shared VPC
export SHARED_VPC=true
export SHARED_VPC_PROJECT_ID=<shared VPC project ID>
export SHARED_VPC_NAME=<shared VPC name>
export SHARED_VPC_SUBNET_NAME=<shared VPC subnet name>
export POD_IP_RANGE_NAME=<the name of the secondary IP range used for cluster pod IPs>
export SERVICE_IP_RANGE_NAME=<the name of the secondary IP range used for cluster services>
```

## Configure the GKE cluster

#### Configure GKE Cluster with Private Endpoint

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

#### Configure GKE Cluster with Public endpoint

This cluster features cluster nodes with private IP's and a control plane api with a public IP.

The code in the `scripts` directory generates and populates terraform variable information and creates all the same resources as the private endpoint cluster with the exception of the bastion host, which is not created. 

Store external IP of the client you plan to run commands from as local variable ```AUTH_IP```:

```shell
# export your Public IP Address
export AUTH_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
```

Verify ```AUTH_IP``` stored your external IP address before moving forward. If not, use an alternate means to update ```AUTH_IP``` with the external IP address for the console: 

```shell
# Check AUTH_IP for external IP
echo $AUTH_IP
```
In the root of this repository, there is a script to create the cluster:

```shell
# Create cluster
make create
```

## Validate GKE cluster config

#### Kubernetes App Layer Secrets Validation

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



#### GKE Cluster with Windows Nodepool Validation (If Windows Node Pools were selected)

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

#### Check the [FAQ](FAQ.md) if you run into issues with the build.

## Cleaning up

Running the command below will destroy all resources with the exception of the Cloud KMS, Key Rings and Keys created by this deployment. Futher deployments will create a new key ring and keys for use by the cluster. This is due to a feature in Cloud KMS requiring a [24 hour scheduled deletion of keys](https://cloud.google.com/kms/docs/faq#cannot_delete). Because of this, it is recommended to manually schedule the deletion of key rings and keys created while testing this deployment. 

```shell
make destroy

```

NOTE: Cloud KMS resources are removed from terraform state resulting in the following error when executing a `terraform destroy`. This error can be safely ignored: 

<img src="../assets/invalid-function-on-destroy.png" alt="invalid-function-on-destroy" width="900"/>
