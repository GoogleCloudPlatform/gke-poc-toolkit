# GKE Cluster Deployments

## Before you start

The provided scripts will populate the required variables from the region, zone, and project envars.

```shell
export REGION=<target compute region for gke>
export ZONE=<target compute zone for bastion host>
export PROJECT=<GCP Project>
```

## GKE Cluster with Private Endpoint

This cluster features both private nodes and a private control plane node.

The code in the `scripts` directory generates and populates terraform variable information and creates the following resources in the region, zone, and project specified:

* GKE Cluster with Private Endpoint
  * Workload Identity Enabled - 
  * Master Authorized Networks enabled - Allows traffic from specified IP addresses to the GKE Control plane
  * Custom Service Accounts for GKE Nodes - 

* VPC Networks
  * subnets
  * firewall rules
  * Cloud NAT - provide outbound internet access for the clusters
  * Cloud Routers

* Compute Engine instance - acts as a bastion host, mapped to the GKE Cluster's Master Authorized Network

In the root of this repository, there is a script to create the cluster:

```shell
make create CLUSTER=private
```

Once the GKE cluster has been created, establish an SSH tunnel to the bastion:

```shell
make start-proxy
```

Set the `HTTPS_PROXY` environment variable to forward kubectl commands through the tunnel: 

```shell
HTTPS_PROXY=localhost:8888 kubectl get ns
```

Stopping the SSH Tunnel:

```shell
make stop-proxy
```

## GKE Cluster with Public endpoint

This cluster features cluster nodes with private IP's and a control plane node with a public IP.

The code in the `scripts` directory generates and populates terraform variable information and creates the following resources in the region, zone, and project specified:

* GKE Cluster with Private Endpoint
  * Workload Identity Enabled
  * Master Authorized Networks enabled 
  * Custom Service Accounts for GKE Nodes

* VPC Networks
  * subnets
  * firewall rules

In the root of this repository, there is a script to create the cluster:

```shell
# export your Public IP Address
export AUTH_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
make create CLUSTER=public
```

### Check the [FAQ](FAQ.md) if you run into issues with the build.

### Next steps

[GKE Hardening Instructions](SECURITY.md)

### Cleaning up

Remove the cluster:

```shell
make destroy CLUSTER=<private|public>
```
