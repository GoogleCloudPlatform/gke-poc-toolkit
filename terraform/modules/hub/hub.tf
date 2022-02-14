variable "project_id" {
}

variable "cluster_config" {
}

// Enable APIs needed in the gke cluster project
module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.3.1"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "anthos.googleapis.com",
    "gkehub.googleapis.com",
  ]
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