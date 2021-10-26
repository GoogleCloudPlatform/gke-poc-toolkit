#!/bin/sh
set -x 

# Create temp dir 
NOW=`date +'%m%d%Y%H%M'`
TEMP_DIR="gke-poc-toolkit-csr-${NOW}"
mkdir -p $TEMP_DIR
cd $TEMP_DIR

echo "Project ID is: ${PROJECT_ID}"

# Clone the user's GCR repo
gcloud source repos clone gke-poc-config-sync --project=$PROJECT_ID
cd gke-poc-config-sync 

# Copy contents of bootstrap dir into user's CSR repo 
cp -r ../../pkg/postcreate/config-sync-bootstrap/* .

# Git commit, git push 
git add .
git commit -m "$NOW - GKE PoC Toolkit: Bootstrap Config Sync repo" 
git push -u origin main 

## exit temp dir 
cd ..
