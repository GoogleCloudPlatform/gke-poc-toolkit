// Defines vars so that we can pass them in from cluster_build/main.tf from the overall tfvars
variable "project_id" {
}

variable "cluster_config" {
}

// enable Multi-cluster gateway project wide
resource "google_gke_hub_feature" "feature" {
  name       = "multiclusterservicediscovery"
  location   = "global"
  project    = var.project_id
  provider   = google-beta
}

// Register each cluster to GKE Hub (Fleets API)
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature_membership#configmanagement 
resource "google_gke_hub_membership" "membership" {
  provider = google-beta
  for_each = var.cluster_config
  project  = var.project_id

  membership_id = "${each.key}-membership"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/projects/${var.project_id}/locations/${each.value.region}/clusters/${each.key}"
    }
  }
}

module "service_account-iam-bindings" {
  depends_on = [
    resource.google_gke_hub_membership.membership,
  ]
  source = "terraform-google-modules/iam/google//modules/service_accounts_iam"

  service_accounts = "serviceAccount:${module.enabled_google_apis.project_id}.svc.id.goog[gke-mcs/gke-mcs-importer]"
  project          = module.enabled_google_apis.project_id
  bindings = "roles/compute.networkViewer"
}

