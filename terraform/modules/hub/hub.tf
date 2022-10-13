variable "project_id" {
}

variable "regional_clusters" {
}

variable "cluster_config" {
}

data "google_project" "project" {
  project_id = var.project_id
}

locals {
    location = var.regional ? each.value.region : each.value.zones[0]
}

// Create IAM binding allowing the hub project's GKE Hub service account access to the registered member project
resource "google_project_iam_binding" "gkehub-serviceagent" {
  role    = "roles/gkehub.serviceAgent"
  project = var.project_id
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-gkehub.iam.gserviceaccount.com",
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
      resource_link = "//container.googleapis.com/projects/${var.project_id}/locations/${local.location}/clusters/${each.key}"
    }
  }
  authority {
    issuer = "https://container.googleapis.com/v1/projects/${var.project_id}/locations/${local.location}/clusters/${each.key}"
  }
}