module "acm" {
  depends_on = [
    module.hub,
  ]
  count             = var.config_sync ? 1 : 0
  source            = "./acm"
  project_id        = module.enabled_google_apis.project_id
  policy_controller = var.policy_controller
  cluster_config    = var.cluster_config
  email             = data.google_client_openid_userinfo.me.email
}

module "mcg" {
  depends_on = [
    module.hub,
  ]
  count                 = var.multi_cluster_gateway ? 1 : 0
  source                = "./mcg"
  project_id            = module.enabled_google_apis.project_id
  cluster_config        = var.cluster_config
  vpc_project_id        = var.vpc_project_id
  vpc_name              = var.vpc_name
  shared_vpc            = var.shared_vpc
}

module "hub" {
  count          = var.multi_cluster_gateway || var.config_sync ? 1 : 0
  source         = "./hub"
  project_id     = module.enabled_google_apis.project_id
  cluster_config = var.cluster_config
}