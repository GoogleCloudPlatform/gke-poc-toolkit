# GKE PoC Toolkit

* [Introduction](#introduction)
* [Install](#install)
* [Quickstart](#quickstart)
* [What's next?](#what's-next)

## Introduction

The GKE Proof of Concept (PoC) Toolkit is a demo generator for Google Kubernetes Engine (GKE). It sets out to provide a set of infrastructure as code (IaC) which deploys GKE clusters with a strong security posture that can be used to step through demos, stand up a POC, and deliver a codified example which can be the basis of a production implementation in your own CICD pipelines.

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

### Multi-cluster shared VPC

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
