# GKE PoC Toolkit

* [Introduction](#introduction)
* [Pre-requisites](#pre-requisites)
* [Deploy a Cluster](#deploy-a-cluster)
* [Harden GKE Security](#harden-gke-security)

## Introduction

Private clusters allow you to isolate nodes from the public internet
Every GKE cluster has a Kubernetes API server that is managed by the control plane (master). The control plane runs on a VM that is in a VPC network in a Google-owned project.

In private clusters, the control plane's VPC network is connected to your cluster's VPC network with VPC Network Peering. Your VPC network contains the cluster nodes, and a separate Google Cloud VPC network contains your cluster's control plane. The control plane's VPC network is located in a project controlled by Google. Traffic between nodes and the control plane is routed entirely using internal IP addresses.

Private clusters also restrict access to the internet by default. A NAT gateway of some form needs to be deployed should you want to enable internet access to pods running in private clusters. Keep in mind this includes base container images not stored in the container registries that google cloud mantains. In the following examples, a Google Cloud Nat Gateway is deployed alongs side the GKE clusters. 

![Private Cluster Architecture](/assets/private-cluster.svg)

The examples in this repository will build GKE Private clusters with access to the control plane restricted in one of two configurations:

* [Private Endpoint](docs/CLUSTERS.md#GKE-Cluster-with-private-endpoint):
  * Public endpoint for control plane is disabled
  * Nodes receive private IP addresses
  * Restricts access to addresses specified in the authorized networks list
  * Authorized networks range must containe internal IP addresses

* [Public Endpoint](docs/CLUSTERS.md#GKE-Cluster-with-public-endpoint):
  * Public endpoint for control plane is enabled
  * Nodes receive private IP addresses
  * Restricts access to addresses specified in the authorized networks list
  * Authorized networks range can contain internal or public IP addresss

Once the cluster is created, the following items are layered on to explore security considerations for the cluster:

* [Audit Logging](docs/SECURITY.md#Audit-Logging)
  * Creates Log Sinks and BigQuery Datasets for Cloud Audit Logs and GKE Audit Logs

* [RBAC](docs/SECURITY.md#RoleBased-Access-Control)
  * Maps GCP Service Accounts to Kubernetes ClusterRoles
  * 2 Service Accounts created with identical GCP IAM Roles
  * Individually mapped to Kubernetes Roles of Viewer and Editor

* [Workload Identity](docs/SECURITY.md#Workload-Identity)
  * Maps a GCP Service Account to Kubernetes Service Account
  * GCP Service Account has GCS Storage Permissions and Workload Identity 
  * 2 Identical Kubernetes deployments with different Kubernetes Service Accounts

## Pre-requisites

The steps described in this document require the installation of several tools and the proper configuration of authentication to allow them to access your GCP resources.

### Cloud Project

You'll need access to a Google Cloud Project with billing enabled. See **Creating and Managing Projects** (https://cloud.google.com/resource-manager/docs/creating-managing-projects) for creating a new project. To make cleanup easier it's recommended to create a new project.

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

The kubectl CLI is used to interteract with both Kubernetes Engine and kubernetes in general.
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

## Harden GKE Security

[Centralized Logs](docs/SECURITY.md)

