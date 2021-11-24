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
# resource "google_gke_hub_membership" "membership" {
#   provider = google-beta
#   for_each = var.cluster_config
#   project  = var.project_id

#   membership_id = "${each.key}-membership"
#   endpoint {
#     gke_cluster {
#       resource_link = "//container.googleapis.com/projects/${var.project_id}/locations/${each.value.region}/clusters/${each.key}"
#     }
#   }
# }

resource "google_project_iam_binding" "network-viewer-mcgsa" {
  role    = "roles/compute.networkViewer"
  project = var.project_id
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[gke-mcs/gke-mcs-importer]",
  ]
}

