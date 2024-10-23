/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

data "google_project" "fleet_project" {
  project_id = var.fleet_project
}

// Hydrate 
locals{
  whereami_openapi_spec = <<-EOT
    swagger: "2.0"
    info:
      description: "Cloud Endpoints DNS"
      title: "Cloud Endpoints DNS"
      version: "1.0.0"
    paths: {}
    host: "whereami.endpoints.${var.fleet_project}.cloud.goog"
    x-google-endpoints:
    - name: "whereami.endpoints.${var.fleet_project}.cloud.goog"
      target: ${google_compute_global_address.whereami_ip.address}
  EOT 

  inference_openapi_spec = <<-EOT
    swagger: "2.0"
    info:
      description: "Cloud Endpoints DNS"
      title: "Cloud Endpoints DNS"
      version: "1.0.0"
    paths: {}
    host: "inference.endpoints.${var.fleet_project}.cloud.goog"
    x-google-endpoints:
    - name: "inference.endpoints.${var.fleet_project}.cloud.goog"
      target: ${google_compute_global_address.inference_ip.address}
  EOT 
}

// Public IP & endpoint for whereami app 
resource "google_compute_global_address" "whereami_ip" {
  name = "whereami-ip"
  project        = var.fleet_project
}

resource "google_endpoints_service" "whereami_service" {
  service_name   = "whereami.endpoints.${var.fleet_project}.cloud.goog"
  project        = var.fleet_project
  openapi_config = local.whereami_openapi_spec
  depends_on     = [
      resource.google_compute_global_address.whereami_ip,
      module.enabled_service_project_apis,
    ]
}

// Public IP for inference app 
resource "google_compute_global_address" "inference_ip" {
  name = "inference-ip"
  project        = var.fleet_project
}

resource "google_endpoints_service" "inference_service" {
  service_name   = "inference.endpoints.${var.fleet_project}.cloud.goog"
  project        = var.fleet_project
  openapi_config = local.inference_openapi_spec
  depends_on     = [
    resource.google_compute_global_address.inference_ip,
    module.enabled_service_project_apis,
    ]
}

resource "google_certificate_manager_certificate_map" "mcg_certificate_map" {
  name        = "mcg-cert-map"
  description = "My acceptance test certificate map"
}

resource "google_certificate_manager_certificate_map_entry" "mcg_cert_map_entry" {
  name        = "mcg-cert-map-entry"
  description = "My acceptance test certificate map entry"
  map = google_certificate_manager_certificate_map.mcg_certificate_map.name 
  certificates = [google_certificate_manager_certificate.mcg_certificate.id]
  hostname = "whereami.endpoints.${var.fleet_project}.cloud.goog"
}

resource "google_certificate_manager_certificate" "mcg_certificate" {
  name        = "mcg-cert"
  scope       = "DEFAULT"
  managed {
    domains = [
      "whereami.endpoints.${var.fleet_project}.cloud.goog"
      ]
  }
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
    ranges                  = ["130.211.0.0/22", "35.191.0.0/16"]
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

// enable Multi-cluster service discovery
resource "google_gke_hub_feature" "mcs" {
  name       = "multiclusterservicediscovery"
  location   = "global"
  project    = var.fleet_project
  provider   = google-beta
  depends_on = [module.enabled_service_project_apis]
}

// enable Multi-cluster Ingress(also gateway) project wide
resource "google_gke_hub_feature" "mci" {
  name     = "multiclusteringress"
  location = "global"
  project  = var.fleet_project
  spec {
    multiclusteringress {
      config_membership = "projects/${var.project_id}/locations/us-central1/memberships/gke-ap-admin-cp-00"
    }
  }
  depends_on = [
    google_gke_hub_feature.mcs,
    google_container_cluster.admin,
  ]
}

// Create IAM binding granting the fleet host project's GKE Hub service account the GKE Service Agent role for cluster project - ONLY NEEDED IF CLUSTER IS IN NOT IN THE FLEET HOST PROJECT and needs to be done for every cluster project 
resource "google_project_iam_binding" "serviceagent-fleet-member-hubagent" {
  role    = "roles/gkehub.serviceAgent"
  project = var.project_id
  members = [
    "serviceAccount:service-${data.google_project.fleet_project.number}@gcp-sa-mcsd.iam.gserviceaccount.com",
  ]
  depends_on = [google_gke_hub_feature.mcs]
}

// Create IAM binding granting the fleet host project's MCS service account the MCS Service Agent role for cluster project - this needs to be done for every cluster project
resource "google_project_iam_binding" "serviceagent-fleet-member-mcsagent" {
  role    = "roles/multiclusterservicediscovery.serviceAgent"
  project = var.project_id
  members = [
    "serviceAccount:service-${data.google_project.fleet_project.number}@gcp-sa-mcsd.iam.gserviceaccount.com",
  ]
  depends_on = [google_gke_hub_feature.mcs]
}

// Create IAM binding granting the fleet host project MCS service account the MCS Service Agent role on the Shared VPC host project 
resource "google_project_iam_binding" "serviceagent-fleet-host" {
  role    = "roles/multiclusterservicediscovery.serviceAgent"
  project = var.shared_vpc ? var.vpc_project_id : var.project_id
  members = [
    "serviceAccount:service-${data.google_project.fleet_project.number}@gcp-sa-mcsd.iam.gserviceaccount.com",
  ]
  depends_on = [google_gke_hub_feature.mcs]
}

// Create IAM binding granting the fleet host project MCS service account the MCS Service Agent role on the Shared VPC host project
resource "google_project_iam_binding" "network-viewer-fleet-host" {
  role    = "roles/compute.networkViewer"
  project = var.shared_vpc ? var.vpc_project_id : var.project_id
  members = [
    "serviceAccount:${var.fleet_project}.svc.id.goog[gke-mcs/gke-mcs-importer]",
  ]
  depends_on = [google_gke_hub_feature.mcs]
}



// Create IAM binding granting the fleet host project MCS service account the MCS Service Agent role on the Shared VPC host project
resource "google_project_iam_binding" "network-viewer-member" {
  role    = "roles/compute.networkViewer"
  project = var.fleet_project
  members = [
    "serviceAccount:${var.fleet_project}.svc.id.goog[gke-mcs/gke-mcs-importer]",
  ]
  depends_on = [google_gke_hub_feature.mcs]
}
