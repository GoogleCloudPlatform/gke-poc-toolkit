module "cluster_build" {
  source                            = "{{.TFModuleRepo}}cluster_build?ref={{.TFModuleBranch}}"
  project_id                        = var.project_id
  fleet_project                     = var.fleet_project
  regional_clusters                 = var.regional_clusters
  shared_vpc                        = var.shared_vpc
  vpc_name                          = var.vpc_name
  vpc_project_id                    = var.vpc_project_id
  vpc_ip_range_pods_name            = var.vpc_ip_range_pods_name
  vpc_ip_range_services_name        = var.vpc_ip_range_services_name
  release_channel                   = var.release_channel
  initial_node_count                = var.initial_node_count
  min_node_count                    = var.min_node_count
  max_node_count                    = var.max_node_count
  linux_machine_type                = var.linux_machine_type
  private_endpoint                  = var.private_endpoint
  authenticator_security_group = var.authenticator_security_group
  # auth_cidr                         = var.auth_cidr
  cluster_config                    = var.cluster_config
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "fleet_project" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "regional_clusters" {
  type        = bool
  description = "Enable regional control plane."
  default     = true
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

variable "authenticator_security_group" {
  type        = string
  description = "The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com"
  default     = null
}

variable "initial_node_count" {
  type    = number
  default = 1
}

variable "min_node_count" {
  type    = number
  default = 1
}

variable "max_node_count" {
  type    = number
  default = 10
}

variable "linux_machine_type" {
  type    = string
  default = "n1-standard-2"
}

variable "private_endpoint" {
  type    = bool
  default = false
}

# Need this default to run PR build test
# variable "auth_cidr" {
#   type    = string
#   default = "1.2.3.4/0"
# }

variable "cluster_config" {
  description = "For each cluster, create an object that contain the required fields"
  default     = {}
}