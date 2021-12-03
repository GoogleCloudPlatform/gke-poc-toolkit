module "cluster_build" {
  source                = "{{.TFModuleRepo}}anthos"
  project_id            = var.project_id
  policy_controller     = var.policy_controller
  cluster_config        = var.cluster_config
  email                 = data.google_client_openid_userinfo.me.email
  shared_vpc            = var.shared_vpc
  shared_vpc_project_id = var.shared_vpc_project_id
  network_name          = var.shared_vpc ? var.shared_vpc_name : var.vpc_name
}

variable "project_id" {
}

variable "policy_controller" {
}

variable "cluster_config" {
}
variable "shared_vpc_project_id" {
}
variable "shared_vpc" {
}
variable "vpc_name" {
}
variable "shared_vpc_name" {
}