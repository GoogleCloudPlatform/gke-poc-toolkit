/**
 * Copyright 2022 Google LLC
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

resource "google_container_cluster" "primary" {
  depends_on = [
    module.kms,
    module.enabled_google_apis,
    module.enabled_governance_apis,
  ]
  name     = "gke-cluster"
  location = "us-central1"
  node_locations = ["us-central1-b"]
  # enable_autopilot = false
  network = "default"
  networking_mode = "VPC_NATIVE"
  enable_intranode_visibility = true
  datapath_provider = "ADVANCED_DATAPATH"
  # dns_config {
  #   cluster_dns = "CLOUD_DNS"
  #   cluster_dns_scope = "CLUSTER_SCOPE"
  # }
  database_encryption {
    state = "ENCRYPTED"
    key_name = "projects/tf-gke-test-01/locations/us-central1/keyRings/gke/cryptoKeys/gke"
  }
  release_channel {
    # channel = "RAPID"
    channel = "REGULAR"
  }
  binary_authorization {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }
  ip_allocation_policy {
    cluster_secondary_range_name = "cluster"
    services_secondary_range_name = "svc"
  }
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
  }
  workload_identity_config {
    workload_pool = "${data.google_project.project.project_id}.svc.id.goog"
  }
  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = true
    master_ipv4_cidr_block     = "172.16.0.0/28"
    master_global_access_config {
      enabled = true
    }
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/12"
      display_name = "VPC"
    }
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 12
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_locations = ["us-central1-b"]
  initial_node_count       = 12
  autoscaling {
    min_node_count = 1
    max_node_count = 13
  }
  management {
    auto_upgrade       = true
    auto_repair        = true
  }
  node_config {
    preemptible  = false
    machine_type = "e2-medium"
    image_type         = "COS_CONTAINERD"
    disk_type          = "pd-ssd"
    disk_size_gb       = 30
    shielded_instance_config {
      enable_secure_boot = true
      enable_integrity_monitoring = true
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}