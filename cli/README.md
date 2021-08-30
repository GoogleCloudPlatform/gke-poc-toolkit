# GKE POC Toolkit - Command Line Interface 

This subdirectory contains code and sample config for the GKE POC Toolkit CLI. This Golang command-line tool wraps the Terraform scripts used to set up a GKE environment consisting of one or more clusters. 


## Installation 

*TODO* 

## Quick Start 

*TODO* 

## Configuration 

You can run the command-line tool as is, and the CLI will use a set of defaults to set up a single cluster. Note that you do still have to provide an existing GCP project ID, when prompted, as this is the only value that cannot be defaulted. 

You can also customize any of the fields below by providing a YAML config file, formatted like the file below, and run the tool like this: 

``
gkekitctl create --config config.yaml
```

*Output* 



### Sample config.yaml 

```YAML

```
