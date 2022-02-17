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

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "us-central1"
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

variable "bastion_members" {
  type        = list(string)
  description = "List of users, groups, SAs who need access to the bastion host"
  default     = []
}

variable "ip_source_ranges_ssh" {
  type        = list(string)
  description = "Additional source ranges to allow for ssh to bastion host. 35.235.240.0/20 allowed by default for IAP tunnel."
  default     = []
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
  type = string
  default = "regular"
}

variable "node_pool" {
  type    = string
  default = "gke-toolkit-pool"
}

variable "initial_node_count" {
  type    = number
  default = 3
}

variable "min_node_count" {
  type    = number
  default = 3
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

variable "config_sync" {
  type        = bool
  description = "Enable Config Sync on all clusters."
  default     = true
}

variable "policy_controller" {
  type        = bool
  description = "Enable Policy Controller on all clusters."
  default     = true
}

variable "config_connector" {
  type        = bool
  description = "(Beta) Whether ConfigConnector is enabled for this cluster."
  default     = true
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

variable "acm_tf_module_repo" {
  type        = string
  description = "Repo used "
  default     = "github.com/GoogleCloudPlatform/gke-poc-toolkit//terraform/modules/acm"
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

variable "asm_version" {
  type        = string
  description = "ASM version"
  default     = "1.12"
}

variable "asm_package" {
  type        = string
  description = "ASM package"
  default     = "istio-1.12.2-asm.0"
}

variable "asm_release_channel" {
  type        = string
  description = "ASM release channel"
  default     = "regular"
}
