terraform {
  required_providers {
    google = {
      version = "~> 4.40.0"
    }
  }
}

data "google_client_openid_userinfo" "me" {
}

data "google_project" "project" {
  project_id = var.project_id
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "us-central1"
}

resource "google_service_account" "default" {
  account_id   = "gke-sa"
  display_name = "Service Account"
}
module "gke" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  initial_node_count      = 12
  project_id                 = var.project_id
  name                       = "module-test-cluster"
  regional                   = true
  region                     = var.region
  network                    = module.gcp-network.network_name
  subnetwork                 = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods              = local.pods_range_name
  ip_range_services          = local.svc_range_name
  master_ipv4_cidr_block     = "172.16.0.0/28"
  add_cluster_firewall_rules = true
  firewall_inbound_ports     = ["9443", "15017"]
  release_channel            = "RAPID"
  compute_engine_service_account = google_service_account.default.email

  master_authorized_networks = [
    {
      cidr_block   = "10.0.0.0/12"
      display_name = "VPC"
    },
  ]
}

