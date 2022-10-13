module "cluster_build" {
  source                            = "{{.TFModuleRepo}}cluster_build?ref={{.TFModuleBranch}}"
  project_id                        = var.project_id
  governance_project_id             = var.governance_project_id
  regional_clusters                 = var.regional_clusters
  region                            = var.region
  zones                             = var.zones
  shared_vpc                        = var.shared_vpc
  vpc_name                          = var.vpc_name
  ip_range_pods_name                = var.ip_range_pods_name
  vpc_project_id                    = var.vpc_project_id
  vpc_ip_range_pods_name            = var.vpc_ip_range_pods_name
  vpc_ip_range_services_name        = var.vpc_ip_range_services_name
  node_pool                         = var.node_pool
  release_channel                   = var.release_channel
  initial_node_count                = var.initial_node_count
  min_node_count                    = var.min_node_count
  max_node_count                    = var.max_node_count
  linux_machine_type                = var.linux_machine_type
  windows_machine_type              = var.windows_machine_type
  private_endpoint                  = var.private_endpoint
  auth_cidr                         = var.auth_cidr
  config_sync                       = var.config_sync
  config_sync_repo                  = var.config_sync_repo
  policy_controller                 = var.policy_controller
  config_connector                  = var.config_connector
  windows_nodepool                  = var.windows_nodepool
  preemptible_nodes                 = var.preemptible_nodes
  cluster_config                    = var.cluster_config
  k8s_users                         = var.k8s_users
  multi_cluster_gateway             = var.multi_cluster_gateway
  anthos_service_mesh               = var.anthos_service_mesh
}

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

variable "node_pool" {
  type    = string
  default = "gke-toolkit-pool"
}

variable "release_channel" {
  type = string
  default = "regular"
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