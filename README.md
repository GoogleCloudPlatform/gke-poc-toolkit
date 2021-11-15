# GKE PoC Toolkit

* [Introduction](#introduction)
* [Prerequisites](#prereqiusites)
* [Install](#install)
* [Quickstart](#quickstart)
* [What's next?](#what's-next)

## Introduction

The GKE Proof of Concept (PoC) Toolkit is a demo generator for Google Kubernetes Engine (GKE). It sets out to provide a set of infrastructure as code (IaC) which deploys GKE clusters with a strong security posture that can be used to step through demos, stand up a POC, and deliver a codified example which can be the basis of a production implementation in your own CICD pipelines.

## Prerequisites

#### Cloud Project

You'll need access to at least one Google Cloud Project with billing enabled. See **Creating and Managing Projects** (https://cloud.google.com/resource-manager/docs/creating-managing-projects) for creating a new project. To make cleanup easier, it's recommended to create a new project. 

If you are using a Shared VPC, you will need a separate host project for the Shared VPC. 

#### Tools

You'll need the following tools installed in order to deploy the toolkit. 
* bash or bash compatible shell
* [Terraform >= 0.13](https://www.terraform.io/downloads.html)
* [Google Cloud SDK version >= 325.0.0](https://cloud.google.com/sdk/docs/downloads-versioned-archives)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
  >**NOTE:** [It is recommended the major/minor version at least match the current default GKE release channel](https://cloud.google.com/kubernetes-engine/docs/release-notes#current_versions) (version 1.20 at the time of this document).

#### Configure Authentication

The Terraform configuration will execute against your GCP environment and create various resources.  The script will use your personal account to build out these resources.  To setup the default account the script will use, run the following command to select the appropriate account:

`gcloud auth login`

>**NOTE:** If this is your first time deploying, you should also run `gcloud init` and reinitialize your configuration. 

## Install

Clone the repo and move into the cloned directory:

```shell
git clone https://github.com/GoogleCloudPlatform/gke-poc-toolkit.git && cd gke-poc-toolkit
```

Build the cli binary:
```shell
cd cli && go build .
```

Validate cli was installed properly:
```shell
./gkekitctl

# Output should look like:
Tool to quickly deploy some pretty dope GKE demos

Usage:
  gkekitctl [command]

Examples:
        gkekitctl create
	gkectl create --config <file.yaml>
	gkekitctl delete

Available Commands:
  completion  generate the autocompletion script for the specified shell
  create      Create GKE Demo Environment
  delete      delete GKE Demo Environment
  help        Help about any command
```


## Quickstart

### Single stand alone cluster

Default behavior creates a single stand alone cluster. Make sure you have a project created and project ID handy. Run the create command and input the project ID when prompted.

```shell
./gkekitctl create
INFO[0000] ☸️ ----- GKE POC TOOLKIT ----- 🛠
INFO[0000] Enter your Google Cloud Project ID:
```

#### Multi-cluster shared VPC

To create a shared VPC environment and install multiple clusters into the shared VPC pass a config file into the create command. 
There is a sample config file saved to ./cli/samples/multi-cluster.yaml. Update the sample with your specific variables before running the create command!

```
./gkekitctl create --config samples/multi-cluster.yaml
```

## Cleanup

If cleaning up a cluster installed with the cli defualts, simply run:

```shell
./gkekitctl delete
```

Otherwise pass in the same config file used to create the resources:

```shell
./gkekitctl delete --config ./cli/samples/multi-cluster.yaml
```

## What's next?
If you want to get fancy with your clusters, read up on other options in the [architecture doc](docs/architecture.md) and go bananas. There are some validation steps you can run through to prove out some of the security features. One for [cluster security features](docs/cluster-security-validation.md) and another for [workload security features](docs/workload-security-validation.md). We welcome contributions. Please give our [contributing doc](CONTRIBUTING.md) a read and join us!
