module "service_accounts" {
  for_each  = var.k8s_users
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = var.project
  names         = [each.key]
  project_roles = [
    "${var.project}=>roles/container.clusterViewer",
    "${var.project}=>roles/container.viewer"
  ]
  generate_keys = true
}


resource "local_file" "service_account_key" {
  for_each =  module.service_accounts
  filename = "../../creds/${each.value.email}.json"
  content  = each.value.key
}


resource "kubernetes_cluster_role_binding" "auditor" {
  for_each  = var.k8s_users
  metadata {
    name      = each.key
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = each.value
  }
  subject {
    kind      = "User"
    name      = format("%s@%s.iam.gserviceaccount.com", each.key, var.project)
    api_group = "rbac.authorization.k8s.io"
  }
}