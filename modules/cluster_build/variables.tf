/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "governance_project_id" {
  type        = string
  description = "The project ID to host governance resources"
}

variable "regional_clusters" {
  type        = bool
  description = "Enable regional control plane."
  default     = true
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "zones" {
  type        = list(string)
  description = "The zones used in your nodepool"
  default     = ["us-central1-b"]
}

variable "shared_vpc" {
  type        = bool
  description = "boolean value for determining whether to create Standalone VPC or use a preexisting Shared VPC"
  default     = false
}

variable "vpc_name" {
  type        = string
  description = "The name of the network being created to host the cluster in"
  default     = "gke-toolkit-network"
}

variable "ip_range_pods_name" {
  type        = string
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  type        = string
  description = "The secondary ip range to use for pods"
  default     = "ip-range-svc"
}

variable "vpc_project_id" {
  type        = string
  description = "The Share VPC Project ID - This is optional and only valid if a Shared VPC is used"
  default     = ""
}

variable "vpc_ip_range_pods_name" {
  type        = string
  description = "The secondary ip range to use for pods in the shared vpc  - This is optional and only valid if a Shared VPC is used"
  default     = ""
}

variable "vpc_ip_range_services_name" {
  type        = string
  description = "The secondary ip range to use for services in the shared vpc  - This is optional and only valid if a Shared VPC is used"
  default     = ""
}

variable "release_channel" {
  type    = string
  default = "regular"
}

variable "node_pool" {
  type    = string
  default = "gke-toolkit-pool"
}

variable "initial_node_count" {
  type    = number
  default = 4
}

variable "min_node_count" {
  type    = number
  default = 4
}

variable "max_node_count" {
  type    = number
  default = 10
}

variable "linux_machine_type" {
  type    = string
  default = "n1-standard-4"
}

variable "windows_machine_type" {
  type    = string
  default = "n1-standard-4"
}

variable "private_endpoint" {
  type    = bool
  default = false
}

# Need this default to run PR build test
variable "auth_cidr" {
  type    = string
  default = "1.2.3.4/0"
}

variable "windows_nodepool" {
  type    = bool
  default = false
}

variable "preemptible_nodes" {
  type        = bool
  description = "Whether underlying node GCE instances are preemptible"
  default     = true
}

variable "cluster_config" {
  description = "For each cluster, create an object that contain the required fields"
  default     = {}
}

variable "k8s_users" {
  type = map(string)
  default = {
    rbac-demo-auditor = "view"
    rbac-demo-editor  = "edit"
  }
}

variable "config_sync" {
  type        = bool
  description = "Enable Config Sync on all clusters."
  default     = true
}

variable "config_sync_repo" {
  type        = string
  description = "Name of Cloud Source Repo for Config Sync"
  default     = "gke-poc-config-sync"
}

variable "policy_controller" {
  type        = bool
  description = "Enable Policy Controller on all clusters."
  default     = true
}

variable "config_connector" {
  type        = bool
  description = "(Beta) Whether ConfigConnector is enabled for this cluster."
  default     = false
}

variable "multi_cluster_gateway" {
  type        = bool
  description = "Enable Multi-cluster gateway on all clusters."
  default     = true
}

variable "anthos_service_mesh" {
  type        = bool
  description = "Enable Anthos Service Mesh on all clusters."
  default     = true
}
variable "gke_module_bypass" {
  type        = bool
  description = "Experimental: Setting this to true allows you to use the TF GKE resource directly instead of the GKE module"
  default     = false
}