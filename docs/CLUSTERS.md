# GKE Cluster Deployments

## Before you start

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

## GKE Cluster with Private Endpoint

This cluster features both private nodes and a private control plane node.

The code in the `scripts` directory generates and populates terraform variable information and creates the following resources in the region, zone, and project specified:

* GKE Cluster with Private Endpoint
  * Workload Identity enabled 
  * A least privileged Google Service Account assigned to compute engine instances
  * Master Authorized Networks enabled - Allows traffic from specified IP addresses to the GKE Control plane
  * Application layer secrets

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
make create CLUSTER=private
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

## GKE Cluster with Public endpoint

This cluster features cluster nodes with private IP's and a control plane node with a public IP.

The code in the `scripts` directory generates and populates terraform variable information and creates the following resources in the region, zone, and project specified:

* GKE Cluster with Private Endpoint
  * Workload Identity enabled 
  * A least privileged Google Service Account assigned to compute engine instances
  * Master Authorized Networks enabled 
  * Application layer secrets

* VPC Networks
  * subnets
  * firewall rules

* Cloud KMS
  * key ring for storing the application layer secret KEK

Store external IP as local variable ```AUTH_IP```:

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
make create CLUSTER=public
```

## Kubernetes App Layer Secrets Validation

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
## Check the [FAQ](FAQ.md) if you run into issues with the build.

## Next steps

[GKE Hardening Instructions](SECURITY.md)

## Cleaning up

Remove the cluster:

```shell
make destroy CLUSTER=<private|public>
```
