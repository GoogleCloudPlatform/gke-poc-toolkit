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

variable "fleet_project" {
  description = "(Optional) Register the cluster with the fleet in this project."
  type        = string
  default     = null
}

variable "vpc_project_id" {
  description = "Shared vpc project needed for setting MCI and MCS RBAC."
  type        = string
  default     = null
}

variable "config_sync_repo" {
  description = "Git repo used as the default config sync repo for your fleet."
  type = string
  default = null
}

variable "config_sync_repo_branch" {
  description = "Git repo branch used as the default config sync repo for your fleet."
  type = string
  default = null
}

variable "config_sync_repo_dir" {
  description = "Git repo directory used as the default config sync repo for your fleet."
  type = string
  default = null
}

variable "shared_vpc" {
  type        = bool
  description = "boolean value for determining whether to create Standalone VPC or use a preexisting Shared VPC"
  default     = false
}

variable "cluster_config" {
}
variable "vpc_name" {
}
