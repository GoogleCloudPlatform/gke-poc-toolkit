module "shared_vpc" {
  source                            = "github.com/knee-berts/gke-poc-toolkit//terraform/modules/shared_vpc"
  project_id                        = var.project_id
  shared_vpc_project_id             = var.shared_vpc_project_id
  region                            = var.region
  shared_vpc_name                   = var.shared_vpc_name
  shared_vpc_ip_range_pods_name     = var.shared_vpc_ip_range_pods_name
  shared_vpc_ip_range_services_name = var.shared_vpc_ip_range_services_name
  cluster_config                    = var.cluster_config
}