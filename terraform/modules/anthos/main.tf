
module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 10.0"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "sourcerepo.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "anthos.googleapis.com",
    "gkehub.googleapis.com",
    "multiclusterservicediscovery.googleapis.com",
    "multiclusteringress.googleapis.com",
    "trafficdirector.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "dns.googleapis.com",
  ]
}

module "acm" {
  depends_on = [
    module.hub,
  ]
  count             = var.config_sync ? 1 : 0
  source            = "./acm"
  project_id        = var.project_id
  policy_controller = var.policy_controller
  cluster_config    = var.cluster_config
  email             = var.email
}

module "mcg" {
  depends_on = [
    module.hub,
  ]
  count                 = var.multi_cluster_gateway ? 1 : 0
  source                = "./mcg"
  project_id            = var.project_id
  cluster_config        = var.cluster_config
  vpc_project_id        = var.vpc_project_id
  vpc_name              = var.vpc_name
  shared_vpc            = var.shared_vpc
}

module "hub" {
  count          = var.multi_cluster_gateway || var.config_sync ? 1 : 0
  source         = "./hub"
  project_id     = var.project_id
  cluster_config = var.cluster_config
    depends_on = [
    module.enabled_google_apis,
  ]
}