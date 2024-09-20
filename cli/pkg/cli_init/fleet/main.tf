module "fleet" {
  source                            = "{{.TFModuleRepo}}fleet?ref={{.TFModuleBranch}}"
  project_id                        = var.project_id
  fleet_project                     = var.fleet_project
  config_sync_repo                  = var.config_sync_repo
  config_sync_repo_branch           = var.config_sync_repo_branch
  config_sync_repo_dir              = var.config_sync_repo_dir
  vpc_name                   = var.vpc_name
  vpc_project_id             = var.vpc_project_id
  release_channel    = var.release_channel
  authenticator_security_group = var.authenticator_security_group
}

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

variable "authenticator_security_group" {
  type        = string
  description = "The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com"
  default     = null
}

variable "cluster_config" {
}
variable "vpc_name" {
}