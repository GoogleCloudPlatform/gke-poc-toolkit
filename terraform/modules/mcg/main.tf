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
      config_membership = "${var.cluster_config[0].key}-membership"
    }
  }
  provider = google-beta
}

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

