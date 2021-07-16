# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set  environment variables to provision the cluster
#set PROJECT, if current project has been set.
# export PROJECT=$(gcloud config get-value project)
#set zone
# export ZONE=$(gcloud config get-value compute/zone)
#set GOVERNANCE_PROJECT, replace if it is not curreent project
# export GOVERNANCE_PROJECT=$(gcloud config get-value project)
#If cluster is windows cluster, allowed values: true|false
# export WINDOWS_CLUSTER=false
#If cluster is public or private, set it to false for private cluster,  allowed values: true|false
# export PUBLIC_CLUSTER=false
#where to save terraform state, allowed values: local|gcs   (use gcs for remoate state in cloud storage bucket) 
export STATE=local
#whether need preemptible nodes, allowed values: true|false
# export PREEMPTIBLE_NODES=false
#All shared VPC settings, uncomment the following  lines with proper values 
#export SHARED_VPC=true
#export SHARED_VPC_PROJECT_ID=<shared VPC project ID>
#export SHARED_VPC_NAME=<shared VPC name>
#export SHARED_VPC_SUBNET_NAME=<shared VPC subnet name>
#export POD_IP_RANGE_NAME=<the name of the secondary IP range used for cluster pod IPs>
#export SERVICE_IP_RANGE_NAME=<the name of the secondary IP range used for cluster services>
