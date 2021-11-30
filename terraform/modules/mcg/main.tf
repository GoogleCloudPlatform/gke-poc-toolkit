// Defines vars so that we can pass them in from cluster_build/main.tf from the overall tfvars
variable "project_id" {
}

variable "cluster_config" {
}

data "google_project" "project" {
  project_id = var.project_id
}

// enable Multi-cluster service discovery
resource "google_gke_hub_feature" "mcs" {
  name       = "multiclusterservicediscovery"
  location   = "global"
  project    = var.project_id
  provider   = google-beta
}

// enable Multi-cluster Ingress(also gateway) project wide
resource "google_gke_hub_feature" "mci" {
  name = "multiclusteringress"
  location = "global"
  project    = var.project_id
  spec {
    multiclusteringress {
      config_membership = "${var.cluster_config.key[0]}-membership"
    }
  }
  provider = google-beta
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

resource "google_project_iam_binding" "network-viewer-mcssa" {
  role    = "roles/compute.networkViewer"
  project = var.project_id
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[gke-mcs/gke-mcs-importer]",
  ]
}

resource "google_project_iam_binding" "network-viewer-mcgsa" {
  role    = "roles/container.admin"
  project = var.project_id
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-multiclusteringress.iam.gserviceaccount.com",
  ]
}

