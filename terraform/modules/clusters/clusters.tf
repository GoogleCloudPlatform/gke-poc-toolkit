/**
 * Copyright 2020 Google LLC
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

# Create clusters listing in the cluster_config variable
resource "google_container_cluster" "gke_ap" {
  for_each           = var.cluster_config
  provider           = google-beta
  name               = each.key
  project            = var.project_id
  location           = each.value.region
  enable_autopilot   = true
  initial_node_count = var.initial_node_count
  network            = "projects/${var.vpc_project_id}/global/networks/${var.vpc_name}"
  subnetwork         = "projects/${var.vpc_project_id}/regions/{${each.value.region}}/subnetworks/${each.value.subnet_name}"
  # networking_mode             = "VPC_NATIVE"
  # datapath_provider           = "ADVANCED_DATAPATH"

  addons_config {
    # HTTP Load Balancing is required to be enabled in Autopilot clusters
    http_load_balancing {
      disabled = false
    }
    # Horizontal Pod Autoscaling is required to be enabled in Autopilot clusters
    horizontal_pod_autoscaling {
      disabled = false
    }
    cloudrun_config {
      disabled = true
    }

    kalm_config {
      enabled = false
    }
    config_connector_config {
      enabled = false
    }
    gke_backup_agent_config {
      enabled = true
    }
  }

  authenticator_groups_config { security_group = var.authenticator_security_group }
  cluster_autoscaling { autoscaling_profile = "OPTIMIZE_UTILIZATION" }
  cost_management_config { enabled = true }
  deletion_protection = false
  fleet { project = var.fleet_project }
  gateway_api_config { channel = "CHANNEL_STANDARD" }
  ip_allocation_policy {
    cluster_secondary_range_name  = var.vpc_ip_range_pods_name
    services_secondary_range_name = var.vpc_ip_range_services_name
  }
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS", "APISERVER", "CONTROLLER_MANAGER", "SCHEDULER"]
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/8"
      display_name = "Internal VMs"
    }
  }
  monitoring_config {
    managed_prometheus { enabled = true }
    enable_components = ["SYSTEM_COMPONENTS", "APISERVER", "CONTROLLER_MANAGER", "SCHEDULER", "STORAGE", "HPA", "POD", "DAEMONSET", "DEPLOYMENT", "STATEFULSET", "KUBELET", "CADVISOR", "DCGM"]
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.${index(keys(var.cluster_config), each.key)}.16/28"
    master_global_access_config {
      enabled = true
    }
  }
  release_channel { channel = var.release_channel }
  secret_manager_config { enabled = true }

  security_posture_config {
    mode               = "ENTERPRISE"
    vulnerability_mode = "VULNERABILITY_ENTERPRISE"
  }
}
