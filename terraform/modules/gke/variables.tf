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

variable "network" {
  type        = string
  description = "The name of the network being created to host the cluster in"
}

variable "ip_range_pods" {
  type        = string
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_services" {
  type        = string
  description = "The secondary ip range to use for pods"
  default     = "ip-range-svc"
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