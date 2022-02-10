// Defines vars so that we can pass them in from cluster_build/main.tf from the overall tfvars
variable "project_id" {
}

variable "vpc_project_id" {
}
variable "cluster_config" {
}
variable "vpc_name" {
}
variable "gateway_crds_version" {
  default = "v0.3.0"     
}

data "google_project" "project" {
  project_id = var.project_id
}

// https://cloud.google.com/kubernetes-engine/docs/how-to/multi-cluster-ingress-setup#shared_vpc_deployment 
module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.vpc_project_id
  network_name = var.vpc_name

  rules = [{
    name                    = "allow-glcb-backend-ingress"
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["130.211.0.0/22","35.191.0.0/16"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["0-65535"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]
}

// Install gateway api crds on each cluster
resource "null_resource" "exec_mcg_crds" {
  for_each = var.cluster_config
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = "scripts/install_crds.sh"
    working_dir = path.module    
    environment = {
      CLUSTER    = each.key
      LOCATION   = each.value.region
      PROJECT_ID    = var.project_id
      GATEWAY_API_VERSION = var.gateway_crds_version
    }
  }
}

// enable Multi-cluster service discovery
resource "google_gke_hub_feature" "mcs" {
  name = "multiclusterservicediscovery"
  location = "global"
  project  = var.project_id
  provider = google-beta
}

// enable Multi-cluster Ingress(also gateway) project wide
resource "google_gke_hub_feature" "mci" {
  depends_on = [
    null_resource.exec_mcg_crds,
  ]
  name = "multiclusteringress"
  location = "global"
  project  = var.project_id
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
  project = var.vpc_project_id
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