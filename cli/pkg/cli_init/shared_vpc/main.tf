module "shared_vpc" {
  source                            = "{{.TFModuleRepo}}shared_vpc?ref={{.TFModuleBranch}}"
  project_id                        = var.project_id
  vpc_project_id                    = var.vpc_project_id
  region                            = var.region
  vpc_name                          = var.vpc_name
  vpc_ip_range_pods_name            = var.vpc_ip_range_pods_name
  vpc_ip_range_services_name        = var.vpc_ip_range_services_name
  cluster_config                    = var.cluster_config
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "vpc_project_id" {
  type        = string
  description = "The Share VPC Project ID - This is optional and only valid if a Shared VPC is used"
  default     = ""
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "vpc_name" {
  type        = string
  description = "The name of the Shared VPC - This is optional and only valid if a Shared VPC is used"
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

variable "cluster_config" {
  description = "For each cluster, create an object that contain the required fields"
  default     = {}
}