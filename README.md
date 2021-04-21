# GKE PoC Toolkit

* [Introduction](#introduction)
* [Pre-requisites](#pre-requisites)
* [Deploy a Cluster](#deploy-a-cluster)
* [Harden GKE Security](#harden-gke-security)
* [Deploy Secure GKE Workloads](#deploy-secure-gke-workloads)

## Introduction

Private clusters allow you to isolate nodes from the public internet.
Every GKE cluster has a Kubernetes API server that is managed by the control plane (master). The control plane runs on a VM that is in a VPC network in a Google-owned project.

In private clusters, the control plane's VPC network is connected to your cluster's VPC network with VPC Network Peering. Your VPC network contains the cluster nodes, and a separate Google Cloud VPC network contains your cluster's control plane. The control plane's VPC network is located in a project controlled by Google. Traffic between nodes and the control plane is routed entirely using internal IP addresses.

Private clusters also restrict access to the internet by default. A NAT gateway of some form needs to be deployed should you want to enable outbound internet access from pods running in private clusters. Keep in mind this includes base container images not stored in the container registries that Google cloud maintains. In the following examples, a Google Cloud Nat Gateway is deployed alongs side the GKE clusters. 

![Private Cluster Architecture](/assets/private-cluster.svg)

## Prerequisites

The steps described in this document require the installation of several tools and the proper configuration of authentication to allow them to access your GCP resources.

### Cloud Project

You'll need access to a Google Cloud Project with billing enabled. See **Creating and Managing Projects** (https://cloud.google.com/resource-manager/docs/creating-managing-projects) for creating a new project. To make cleanup easier, it's recommended to create a new project.

### Required GCP APIs

The following APIs will be enabled in your projects:

* Cloud Resource Manager API
* Kubernetes Engine API
* Stackdriver Logging API
* Stackdriver Monitoring API
* BigQuery API
* Identity Aware Proxy API
* Google Cloud Storage API

### Tools

* [Terraform >= 0.13](https://www.terraform.io/downloads.html)
* [Google Cloud SDK version >= 325.0.0](https://cloud.google.com/sdk/docs/downloads-versioned-archives)
* [kubectl matching the latest GKE version](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* bash or bash compatible shell

#### Install Cloud SDK

The Google Cloud SDK is used to interact with your GCP resources.
[Installation instructions](https://cloud.google.com/sdk/downloads) for multiple platforms are available online.

#### Install kubectl CLI

The kubectl CLI is used to interact with both Kubernetes Engine and kubernetes in general.
[Installation instructions](https://cloud.google.com/kubernetes-engine/docs/quickstart)
for multiple platforms are available online.

#### Install Terraform

Terraform is used to automate the manipulation of cloud infrastructure. Its
[installation instructions](https://www.terraform.io/intro/getting-started/install.html) are also available online.

#### Configure Authentication

The Terraform configuration will execute against your GCP environment and create various resources.  The script will use your personal account to build out these resources.  To setup the default account the script will use, run the following command to select the appropriate account:

`gcloud auth login`

## Deploy a Cluster

[GKE Cluster Install Instructions](docs/CLUSTERS.md)

The [Deploy a Cluster](docs/CLUSTERS.md) step in this repository will build a GKE Private cluster with access to the control plane restricted in one of two configurations:

* [Private Endpoint](docs/CLUSTERS.md#GKE-Cluster-with-private-endpoint):
  * Public endpoint for control plane is disabled
  * Nodes receive private IP addresses
  * Restricts access to addresses specified in the authorized networks list
  * Authorized networks range must containe internal IP addresses

* [Public Endpoint](docs/CLUSTERS.md#GKE-Cluster-with-public-endpoint):
  * Public endpoint for control plane is enabled
  * Nodes receive private IP addresses
  * Restricts access to addresses specified in the authorized networks list
  * Authorized networks range can contain internal or public IP addresses

The following best practices are also enforced as part of the cluster build process:

* [Least Privilege Service Accounts](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster#use_least_privilege_sa)
  * The build process generates a service account used for running the GKE nodes. This service account operates under the concept of least privilege and only has permissions needed for sending logging data, metrics, and downloading containers from the given GCR project. 

* [Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity):
  * Workload identity is enabled on this cluster and is a way to securely provide access to Google cloud services within your Kubernetes cluster. This allows administrators to bind a Google cloud service account with the roles and/or permissions required to a Kubernetes Service account. An annotation on the service account then references the GCP service account to access the Google cloud services within your cluster.

* [Application Layer Secrets](https://cloud.google.com/kubernetes-engine/docs/how-to/encrypting-secrets#overview):
  * Application Layer Secrets are used to provide an additional layer of security for sensitive data stored in etcd. The build process creates a [Cloud KMS](https://cloud.google.com/kms/docs) which stores the Key Encrption Key (KEK) used to encrypt data at the application layer. 

## Harden GKE Security

[GKE Hardening Instructions](docs/SECURITY.md)

Once the cluster is created, the [Harden GKE Security](docs/SECURITY.md) step can be executed against the existing environment. Doing so will layer on the following items to expand security considerations for the cluster:

* [Audit Logging](docs/SECURITY.md#Audit-Logging)
  * Creates BigQuery Datasets for Cloud Audit Logs and GKE Audit Logs
  * Creates log sink and Big Query sink

* [RBAC](docs/SECURITY.md#RoleBased-Access-Control)

  * Maps GCP Service Accounts to Kubernetes ClusterRoles
    * Two Service Accounts created with identical GCP IAM Roles - IAM roles needed for accessing cluster config
    * Individually mapped to Kubernetes Roles of Viewer and Editor - Simulate auditor and cluster administrator role permissions

## Deploy Secure GKE Workloads

[Deploy Secure GKE Workloads Instructions](docs/WORKLOADS.md)

Once hardening controls have been enforced, the [Deploy Secure GKE Workloads](docs/WORKLOADS.md) step provides examples on how to secure workloads deployed to the cluster. This step leverages [Config Connector](https://cloud.google.com/config-connector/docs/overview) to deploy services and resources using Kubernetes tooling and APIs. The following security features are layed into the application deployment:

* [Workload Identity](docs/SECURITY.md#Workload-Identity)
  * Leveraging Workload Identity, map a GCP Service Account to a Kubernetes Service Account
  * Grant GCP Service Account GCS Storage Permissions
  * Deploy a sample `storage-application` that leverages that identity to access a GCP storage bucket

