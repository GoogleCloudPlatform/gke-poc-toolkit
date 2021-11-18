module "acm" {
  depends_on = [
    module.gke,
  ]
  count             = var.config_sync ? 1 : 0
  source            = "github.com/knee-berts/gke-poc-toolkit//terraform/modules/"
  project_id        = module.enabled_google_apis.project_id
  policy_controller = var.policy_controller
  cluster_config    = var.cluster_config
  email             = data.google_client_openid_userinfo.me.email
}