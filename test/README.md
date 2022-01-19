# End-to-end Tests 

This directory contains Cloud Build pipelines and test scripts for the GKE PoC Toolkit. These tests are designed to assess whether the Toolkit works as intended in default scenarios, eg. for an incoming pull request. 

## How the tests work 

These tests are triggered on any open PR, or any commit to `main`. 

Tests use Cloud Build. All Cloud Build pipelines run in the `gke-poc-toolkit` GCP project, but spawn (and delete) other projects during the test. 

### default-config.yaml (single cluster GKE)

Build uses a custom image with all the prereqs (Terraform, etc.) installed on it. 

Spawn new project with auto hash; connect project to billing 
gcloud login / setup for new project 
Cloud Build pipeline pulls down the repo (at the latest PR commit, or commit to main). 
TEST 1 - Compile (go build CLI)
Creates a separate dir. Copies the newly-built CLI into it. Runs `gkekitctl init` to pull down the samples. 
TEST 2- Functional - `gkekitctl create` into the new project 
Cleanup - Delete project 


## Infrastructure 

https://pantheon.corp.google.com/cloud-build/builds?project=gkepoctoolkit

