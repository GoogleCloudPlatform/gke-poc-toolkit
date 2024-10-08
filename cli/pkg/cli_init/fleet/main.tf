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
  cluster_config                    = var.cluster_config
  shared_vpc                        = var.shared_vpc
  vpc_ip_range_pods_name            = var.vpc_ip_range_pods_name
  vpc_ip_range_services_name        = var.vpc_ip_range_services_name
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "fleet_project" {
  type        = string
  description = "(Optional) Register the cluster with the fleet in this project."
}

variable "vpc_project_id" {
  type        = string
  description = "Shared VPC project needed for setting MCI and MCS RBAC."
}

variable "config_sync_repo" {
  description = "Git repo used as the default config sync repo for your fleet."
  type        = string
  default     = null
}

variable "config_sync_repo_branch" {
  description = "Git repo branch used as the default config sync repo for your fleet."
  type        = string
  default     = null
}

variable "config_sync_repo_dir" {
  description = "Git repo directory used as the default config sync repo for your fleet."
  type        = string
  default     = null
}

variable "shared_vpc" {
  type        = bool
  description = "Determines whether to create a standalone VPC or use an existing Shared VPC"
  default     = false
}

variable "vpc_ip_range_pods_name" {
  type        = string
  description = "The secondary IP range to use for pods in the shared VPC"
  default     = ""
}

variable "vpc_ip_range_services_name" {
  type        = string
  description = "The secondary IP range to use for services in the shared VPC"
  default     = ""
}

variable "release_channel" {
  type        = string
  description = "The release channel of the cluster"
  default     = "regular"
}

variable "authenticator_security_group" {
  type        = string
  description = "The name of the RBAC security group for use with Google security groups in Kubernetes RBAC."
  default     = null
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC - used for shared or local VPC"
  default     = ""
}

variable "cluster_config" {
  type = map(object({
    subnet_name = string
    region      = string
  }))
  description = "For each cluster, create an object that contains the required fields"
  default     = {}
}
