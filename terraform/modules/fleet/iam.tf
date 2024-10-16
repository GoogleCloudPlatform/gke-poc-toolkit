locals {
  # Config Sync Service Account
  cs_service_account       = "cs-service-account"
  cs_service_account_email = "${local.cs_service_account}@${var.fleet_project}.iam.gserviceaccount.com"
  # Hub service account
  hub_service_account_email = format("service-%s@gcp-sa-gkehub.iam.gserviceaccount.com", data.google_project.fleet_project.number)
  hub_service_account       = "serviceAccount:${local.hub_service_account_email}"
}

# Create Hub Service Account
resource "google_project_iam_member" "hubsa" {
  project = var.fleet_project
  role    = "roles/gkehub.serviceAgent"
  member  = local.hub_service_account
  depends_on = [
    module.enabled_service_project_apis,
  ]
}

// create ACM service account 
// Todo - use KSA directly
module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  # version       = "~> 4.2.0"
  project_id    = var.fleet_project
  display_name  = "CS service account"
  names         = [local.cs_service_account]
  project_roles = ["${var.fleet_project}=>roles/source.reader"]
}

module "cs_service_account-iam-bindings" {
  depends_on = [
    resource.google_gke_hub_feature.config_management,
  ]
  source = "terraform-google-modules/iam/google//modules/service_accounts_iam"

  service_accounts = [local.cs_service_account_email]
  project          = var.fleet_project
  bindings = {
    "roles/iam.workloadIdentityUser" = [
      "serviceAccount:${var.fleet_project}.svc.id.goog[config-management-system/root-reconciler]",
    ]
  }
}

module "asm-service_account-iam-bindings" {
  depends_on = [
    resource.google_gke_hub_feature.config_management,
  ]
  source = "terraform-google-modules/iam/google//modules/service_accounts_iam"

  project          = var.fleet_project
  bindings = {
    "roles/secretmanager.secretAccessor" = [
      "serviceAccount:${var.fleet_project}.svc.id.goog[asm-gateways/asm-ingress-gateway]",
    ]
  }
}

module "prom-service_account-iam-bindings" {
  depends_on = [
    resource.google_gke_hub_feature.config_management,
  ]
  source = "terraform-google-modules/iam/google//modules/service_accounts_iam"

  project          = var.fleet_project
  bindings = {
    "roles/monitoring.viewer" = [
      "serviceAccount:${var.fleet_project}.svc.id.goog[custom-metrics/custom-metrics-stackdriver-adapter]",
    ]
  }
}