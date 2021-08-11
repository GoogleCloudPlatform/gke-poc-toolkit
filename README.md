# GKE PoC Toolkit

* [Introduction](#introduction)
* [Pre-requisites](#pre-requisites)
* [Deploy a Cluster](#deploy-a-cluster)
* [Harden GKE Security](#harden-gke-security)
* [Deploy Secure GKE Workloads](#deploy-secure-gke-workloads)

## Introduction

This toolkit sets out to provide a set of infrastructre as code (IaC) which deploys GKE with a strong security posture that can be used to step through demos, stand up a POC, and deliver a codified example that can be the basis of a production implementation your own CICD pipelines.

Terraform modules found in the [Cloud Foundations Toolkit](https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit/blob/master/docs/terraform.md) are used as the bases for all IaC.

[Kuberenetes Config Connector](https://cloud.google.com/config-connector/docs/overview) is used to bootstap GCP resouces that are part of application demos.

## Pre-requisites

The steps described in this document require the installation of several tools and the proper configuration of authentication to allow them to access your GCP resources.

#### Cloud Project

You'll need access to at least one Google Cloud Project with billing enabled. See **Creating and Managing Projects** (https://cloud.google.com/resource-manager/docs/creating-managing-projects) for creating a new project. To make cleanup easier, it's recommended to create a new project.

#### Required GCP APIs

The following APIs will be enabled in your projects:

* Identity and Access Management API
* Compute Engine API
* Cloud Resource Manager API
* Kubernetes Engine API
* Google Container Registry API
* Stackdriver Logging API
* Stackdriver Monitoring API
* BigQuery API
* Identity Aware Proxy API
* Google Cloud Storage API
* Binary Authorization API
* Cloud Key Management Service API

#### Tools

* bash or bash compatible shell
* [Terraform >= 0.13](https://www.terraform.io/downloads.html)
* [Google Cloud SDK version >= 325.0.0](https://cloud.google.com/sdk/docs/downloads-versioned-archives)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
  >**NOTE:** [It is recommended the major/minor version at least match the current default GKE release channel](https://cloud.google.com/kubernetes-engine/docs/release-notes#current_versions) (version 1.20 at the time of this document).

#### Configure Authentication

The Terraform configuration will execute against your GCP environment and create various resources.  The script will use your personal account to build out these resources.  To setup the default account the script will use, run the following command to select the appropriate account:

`gcloud auth login`

>**NOTE:** If this is your first time deploying, you should also run `gcloud init` and reinitialize your configuration. 

## Deploy a Cluster

[GKE Cluster Install Instructions](docs/CLUSTERS.md)

#### Standard Build

This template defaults to deploying a Private Cluster in a Standalone VPC with the settings below. Instructions are included to modify the default build to include optional settings. Those options are covered in the following section, [Optional Settings](#optional-settings).

Private clusters allow you to isolate nodes from the public internet. Every GKE cluster has a Kubernetes API server that is managed by the control plane (master). In private clusters, the control plane's VPC network is connected to your cluster's VPC network with VPC Network Peering. Your VPC network contains the cluster nodes, and a separate Google Cloud VPC network contains your cluster's control plane. The control plane's VPC network is located in a project controlled by Google. Traffic between nodes and the control plane is routed entirely using internal IP addresses.

Private clusters also restrict access to the internet by default. A NAT gateway of some form needs to be deployed should you want to enable outbound internet access from pods running in private clusters. Keep in mind this includes base container images not stored in the container registries that Google cloud maintains. In the following examples, a Google Cloud Nat Gateway is deployed alongs side the GKE clusters. 

The GKE Cluster Install step in this repository will build a GKE Private cluster with access to the control plane with the following configuration:

* [Private Endpoint Cluster](docs/CLUSTERS.md#deploy-a-GKE-Cluster-with-private-endpoint):
  * Public endpoint for control plane is disabled
  * Nodes receive private IP addresses
  * Restricts access to addresses specified in the authorized networks list
  * Authorized networks range must containe internal IP addresses

The following best practices are also enforced as part of the cluster build process:

* [Shielded VMs and Secure Boot](https://cloud.google.com/kubernetes-engine/docs/how-to/shielded-gke-nodes)
  * The GKE cluster and bastion host are deployed with Shielded VMs. Doing so provides strong, verifiable node identity and integrity to increase the security of GCE instances.
  * Additionally, the GKE Shielded nodes are deployed with [Secure Boot](https://cloud.google.com/security/shielded-cloud/shielded-vm#secure-boot). Third-party unsigned kernel modules cannot be loaded when secure boot is enabled.

* [Least Privilege Service Accounts](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster#use_least_privilege_sa)
  * The build process generates a service account used for running the GKE nodes. This service account operates under the concept of least privilege and only has permissions needed for sending logging data, metrics, and downloading containers from the given GCR project. 

* [Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity):
  * Workload identity is enabled on this cluster and is a way to securely provide access to Google cloud services within your Kubernetes cluster. This allows administrators to bind a Google cloud service account with the roles and/or permissions required to a Kubernetes Service account. An annotation on the service account then references the GCP service account to access the Google cloud services within your cluster.

* [Application Layer Secrets](https://cloud.google.com/kubernetes-engine/docs/how-to/encrypting-secrets#overview):
  * Application Layer Secrets are used to provide an additional layer of security for sensitive data stored in etcd. The build process creates a [Cloud KMS](https://cloud.google.com/kms/docs) which stores the Key Encrption Key (KEK) used to encrypt data at the application layer. 

* [Safe-Cluster GKE Module](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest/submodules/safer-cluster):
  * This deployment uses the Safe-Cluster GKE module which fixes a set of parameters to values suggested in the [GKE hardening guide](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster), the CIS framework, and other best practices. Reference the above link for project configurations, cluster settings, and basic kubernetes objects that are provisioned as part of this module and permit a safer-than-default configuration.

#### Optional Settings
The following <b>OPTIONAL</b> configurations are also available and can be enabled by setting the appropriate configuration values prior to deployment. Guidance on how to enable these features can be found in under [Optional Settings](docs/CLUSTERS.md#optional-settings) in the Cluster Build guide:

* [Public Endpoint Cluster](docs/CLUSTERS.md#deploy-a-GKE-Cluster-with-public-endpoint) - The cluster can be deployed with public access to the master endpoints therefore eliminating the need for a bastion host. Doing so configures the cluster as follows:
  * Public endpoint for control plane is enabled
  * Nodes receive private IP addresses
  * Restricts access to addresses specified in the authorized networks list
  * Authorized networks range can contain internal or public IP addresses

* [Windows Node Pool](https://cloud.google.com/kubernetes-engine/docs/concepts/windows-server-gkec) 
  * By default the GKE cluster deploys a linux node pool. Enabling this feature will deploy an additional Windows node pool for deploying Windows Server container workloads.

* [Preemptible Nodes](https://cloud.google.com/kubernetes-engine/docs/how-to/preemptible-vms) 
  * By default the GKE cluster leverages non-preemptible nodes which cannot be reclaimed while in use. Enabling this feature will deploy the GKE cluster with preemptible nodes that last a maximum of 24 hours and provide no availability guarentees.

* [Shared VPC](https://cloud.google.com/vpc/docs/shared-vpc) 
  * By default the GKE cluster deploys to a standalone VPC in the project where the cluster is created. Enabling this feature will deploy the GKE cluster to a shared VPC in a Host Project of your choice.

* [Configure the Shared VPC](https://cloud.google.com/vpc/docs/shared-vpc) 
  * The default Shared VPC configuration assumes the Shared VPC is configured and the Service Project is attached. Performing this step will configure a Shared VPC in a target Host Project and attach the Service Project before deploying the cluster.


## Harden GKE Security

[GKE Hardening Instructions](docs/SECURITY.md)

Once the cluster is created, this step can be executed against the existing environment. Doing so will layer on the following items to expand security considerations for the cluster:

* [Audit Logging](docs/SECURITY.md#Audit-Logging)
  * Creates BigQuery Datasets for Cloud Audit Logs and GKE Audit Logs
  * Creates log sink and Big Query sink

* [RBAC](docs/SECURITY.md#RoleBased-Access-Control)

  * Maps GCP Service Accounts to Kubernetes ClusterRoles
    * Two Service Accounts created with identical GCP IAM Roles - IAM roles needed for accessing cluster config
    * Individually mapped to Kubernetes Roles of Viewer and Editor - Simulate auditor and cluster administrator role permissions

## Deploy Secure GKE Workloads (Linux example)

[Deploy Secure GKE Workloads Instructions](docs/WORKLOADS.md)

This step provides an example of how to enforce security best practices to workloads deployed to a linux GKE cluster. This step leverages [Config Connector](https://cloud.google.com/config-connector/docs/overview) to deploy services and resources using Kubernetes tooling and APIs. The following security features are layed into the application deployment:

* [Workload Identity](docs/SECURITY.md#Workload-Identity)
  * Example deployed to the linux node pool in the cluster
  * Leveraging Workload Identity, map a GCP Service Account to a Kubernetes Service Account
  * Grant GCP Service Account GCS Storage Permissions
  * Deploy a sample `storage-application` that leverages that identity to access a GCP storage bucket

