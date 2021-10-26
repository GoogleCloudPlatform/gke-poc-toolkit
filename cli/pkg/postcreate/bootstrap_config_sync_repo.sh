# Copyright © 2021 Google Inc.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash
set -x 

# Create temp dir 
NOW=`date +'%m%d%Y%H%M'`
TEMP_DIR="gke-poc-toolkit-csr-${NOW}"
mkdir -p $TEMP_DIR
cd $TEMP_DIR

# Clone the user's GCR repo
gcloud source repos clone gke-poc-config-sync --project=$PROJECT_ID
    cd gke-poc-config-sync 

# Copy contents of bootstrap dir into user's CSR repo 
cp -r ../../config-sync-bootstrap/* .

# Git commit, git push 
git add .
git commit -m "$NOW - GKE PoC Toolkit: Bootstrap Config Sync repo" 
git push -u origin main 

## exit temp dir 
cd ..
