// Defines vars so that we can pass them in from cluster_build/main.tf from the overall tfvars
variable "project_id" {
}

variable "shared_vpc_project_id" {
}
variable "cluster_config" {
}
data "google_project" "project" {
  project_id = var.project_id
}

// Enable APIs needed in the gke clusters project
module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 10.0"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
		"multiclusterservicediscovery.googleapis.com",
		"multiclusteringress.googleapis.com",
		"trafficdirector.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "dns.googleapis.com",
  ]
}

// enable Multi-cluster service discovery
resource "google_gke_hub_feature" "mcs" {
  name       = "multiclusterservicediscovery"
  depends_on = [
    module.enabled_google_apis,
  ]
  location   = "global"
  project    = var.project_id
  provider   = google-beta
}

// enable Multi-cluster Ingress(also gateway) project wide
resource "google_gke_hub_feature" "mci" {
  name = "multiclusteringress"
  depends_on = [
    module.enabled_google_apis,
  ]
  location = "global"
  project    = var.project_id
  spec {
    multiclusteringress {
      config_membership = "projects/${var.project_id}/locations/global/memberships/${keys(var.cluster_config)[0]}-membership"
    }
  }
  provider = google-beta
}

// Create IAM binding allowing the hub project's GKE Hub service account access to the registered member project
resource "google_project_iam_binding" "gkehub-serviceagent" { 
  role    = "roles/gkehub.serviceAgent"
  project = var.project_id
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-gkehub.iam.gserviceaccount.com",
  ]
}

// Create IAM binding allowing the hub project's MCS service account access to the shared vpc project
resource "google_project_iam_binding" "host-serviceagent" {
  role    = "roles/multiclusterservicediscovery.serviceAgent"
  project = var.shared_vpc_project_id
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-gkehub.iam.gserviceaccount.com",
  ]
}

// Create IAM binding allowing the hub project's MCS service account access to the gke cluster project
resource "google_project_iam_binding" "member-serviceagent" {
  role    = "roles/multiclusterservicediscovery.serviceAgent"
  project = var.project_id
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-gkehub.iam.gserviceaccount.com",
  ]
}

resource "google_project_iam_binding" "network-viewer-member" {
  depends_on = [
    resource.google_gke_hub_feature.mcs,
  ]
  role    = "roles/compute.networkViewer"
  project = var.project_id
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[gke-mcs/gke-mcs-importer]",
  ]
}

resource "google_project_iam_binding" "container-admin-mcgsa" {
  role    = "roles/container.admin"
  project = var.project_id
  depends_on = [
    resource.google_gke_hub_feature.mci,
  ]
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-multiclusteringress.iam.gserviceaccount.com",
  ]
}

// This is overkill, waiting on product to give precise role for the MCGSA in shared VPC
resource "google_project_iam_binding" "vpc-admin-mcgsa" {
  role    = "roles/compute.networkAdmin"
  project = var.shared_vpc_project_id
  depends_on = [
    resource.google_gke_hub_feature.mci,
  ]
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-multiclusteringress.iam.gserviceaccount.com",
  ]
}


