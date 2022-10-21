# GKE PoC Toolkit Architecture

- [GKE PoC Toolkit Architecture](#gke-poc-toolkit-architecture)
  - [Introduction](#introduction)
  - [GCP APIs](#gcp-apis)
  - [Secure Defaults](#secure-defaults)
  - [Optional Settings](#optional-settings)

## Introduction
This toolkit is made up of two base components, a cli written in golang, and a set of terraform code. The cli leverages the [cobra](https://github.com/spf13/cobra) and [viper](https://github.com/spf13/viper) packages for cli command and the [terraform-exec](https://github.com/hashicorp/terraform-exec) package to run terraform commands in the go code. Wheels are not being reinvented here, all of the terraform code leverages the [terraform-google-modules](https://github.com/terraform-google-modules) opensourced and maintained by google. 

## GCP APIs

The following GCP APIs will be enabled in your projects:

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

## Secure Defaults

When using the cli defaults, `gkekitctl create`, a Private Cluster in a Standalone VPC with the settings below is built. A config file can be used to customize the install, the spec and examples are kept in this [folder](../cli/samples). Definitions of each configuration choice in the spec are stored in the [configuration.md](configuration.md) doc. The rest of this doc goes over all the non-optional security features every cluster is bootstraped with.

Private clusters allow you to isolate nodes from the public internet. Every GKE cluster has a Kubernetes API server that is managed by the control plane (master). In private clusters, the control plane's VPC network is connected to your cluster's VPC network with VPC Network Peering. Your VPC network contains the cluster nodes, and a separate Google Cloud VPC network contains your cluster's control plane. The control plane's VPC network is located in a project controlled by Google. Traffic between nodes and the control plane is routed entirely using internal IP addresses.

Private clusters also restrict access to the internet by default. A NAT gateway of some form needs to be deployed should you want to enable outbound internet access from pods running in private clusters. Keep in mind this includes base container images not stored in the container registries that Google cloud maintains. In the following examples, a Google Cloud Nat Gateway is deployed alongsside the GKE clusters. 

The GKE Cluster Install step in this repository will build a GKE Private cluster with access to the control plane with the following configuration:

* [Public Endpoint Cluster]() - The cluster can be deployed with public access to the master endpoints therefore eliminating the need for a bastion host. Doing so configures the cluster as follows:
  * Public endpoint for control plane is enabled
  * Nodes receive private IP addresses
  * Restricts access to addresses specified in the authorized networks list
  * Authorized networks range can contain internal or public IP addresses

Should you want to expose the control plane with a private IP, set `privateEndpoint: true` in your config file. When you choose that setting, the following is configured: 

* [Private Endpoint Cluster]():
  * Public endpoint for control plane is disabled
  * Nodes receive private IP addresses
  * Restricts access to addresses specified in the authorized networks list
  * Authorized networks range must containe internal IP addresses

The following security features of GKE are enabled at default and are not exposed to the user as optional:

* [Shielded VMs and Secure Boot](https://cloud.google.com/kubernetes-engine/docs/how-to/shielded-gke-nodes)
  * The GKE cluster and bastion host are deployed with Shielded VMs. Doing so provides strong, verifiable node identity and integrity to increase the security of GCE instances.
  * Additionally, the GKE Shielded nodes are deployed with [Secure Boot](https://cloud.google.com/security/shielded-cloud/shielded-vm#secure-boot). Third-party unsigned kernel modules cannot be loaded when secure boot is enabled.

* [Least Privilege Service Accounts](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster#use_least_privilege_sa)
  * The build process generates a service account used for running the GKE nodes. This service account operates under the concept of least privilege and only has permissions needed for sending logging data, metrics, and downloading containers from the given GCR project. 

* [Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity):
  * Workload identity is enabled on this cluster and is a way to securely provide access to Google cloud services within your Kubernetes cluster. This allows administrators to bind a Google cloud service account with the roles and/or permissions required to a Kubernetes Service account. An annotation on the service account then references the GCP service account to access the Google cloud services within your cluster.

* [Application Layer Secrets](https://cloud.google.com/kubernetes-engine/docs/how-to/encrypting-secrets#overview):
  * Application Layer Secrets are used to provide an additional layer of security for sensitive data stored in [etcd]( https://kubernetes.io/docs/concepts/overview/components/#etcd). The build process creates a [Cloud KMS](https://cloud.google.com/kms/docs) which stores the Key Encrption Key (KEK) used to encrypt data at the application layer. 

* [Safe-Cluster GKE Module](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest/submodules/safer-cluster):
  * This deployment uses the Safe-Cluster GKE module which fixes a set of parameters to values suggested in the [GKE hardening guide](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster), the CIS framework, and other best practices. Reference the above link for project configurations, cluster settings, and basic kubernetes objects that are provisioned as part of this module and permit a safer-than-default configuration.

* [Audit Logging](https://cloud.google.com/logging/docs/audit/understanding-audit-logs):
  * The scripts in this repository will create a set of log sinks for collecting the Audit Logs of the GKE clusters; one targeting a Google Cloud Storage Bucket and one targeting a Big Query data set.  These sinks can be created in either a new centralized Governance project or inside your existing GCP Project. Please reference [this link](https://cloud.google.com/logging/docs/export) for a conceptual overview of log exports and how sinks work. 

* [Role-Based Access Control](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control):
  * Role-based access control (RBAC) is a method of regulating access to computer or network resources based on the roles of individual users within your organization. The scripts in this repository will create two sample Google Cloud Identities, `rbac-demo-auditor` and `rbac-demo-editor`, that have kubernetes 'view' and 'edit' ClusterRoles respectively. After creation, a simple test is provided to demonstrate the scope of permissions. These roles are intended to represent a sample audit and administrative user. 

## Optional Settings
The following <b>OPTIONAL</b> configurations are also available and can be enabled by setting the appropriate configuration values prior to deployment. Guidance on how to enable these features can be found in the [configuration.md](configuration.md) doc:

* [Multiple Clusters](configuration.md#ClusterConfig) - More than one cluster can be deployed with the create command. They can be spread across any region and be customized with the cluster section in the config file.

* [Anthos Config Management](configuration.md#Config) - Enable [Config Sync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview) and/or [Policy Controller](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller) to sync configs and enforce policies across one or multiple GKE clusters. 
 
* [Public Endpoint Cluster](configuration.md#Config) - The cluster can be deployed with public access to the master endpoints therefore eliminating the need for a bastion host. Doing so configures the cluster as follows:
  * Public endpoint for control plane is enabled
  * Nodes receive private IP addresses
  * Restricts access to addresses specified in the authorized networks list
  * Authorized networks range can contain internal or public IP addresses

* [Windows Node Pool](https://cloud.google.com/kubernetes-engine/docs/concepts/windows-server-gkec) 
  * By default the GKE cluster deploys a linux node pool. Enabling this feature will deploy an additional Windows node pool for deploying Windows Server container workloads.

* [Preemptible Nodes](https://cloud.google.com/kubernetes-engine/docs/how-to/preemptible-vms) 
  * By default the GKE cluster leverages non-preemptible nodes which cannot be reclaimed while in use. Enabling this feature will deploy Linux Node pools in the GKE clusters with preemptible nodes that last a maximum of 24 hours and provide no availability guarentees.
  * Windows Node pools do not currently support preemptible nodes and will continue to use non-preemptible nodes. 

* [Shared VPC](https://cloud.google.com/vpc/docs/shared-vpc) 
  * By default the GKE cluster deploys to a standalone VPC in the project where the cluster is created. Enabling this feature will deploy a shared VPC and put all GKE clusters in that shared VPC's subnets.
