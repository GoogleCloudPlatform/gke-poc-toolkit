
# module "gke" {
#   deletion_protection                  = false
#   source                               = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
#   authenticator_security_group         = var.authenticator_security_group
#   enable_cost_allocation               = true
#   enable_private_endpoint              = true
#   gke_backup_agent_config              = true
#   project_id                           = var.project_id
#   fleet_project                        = var.fleet_project
#   network                              = var.vpc_name
#   ip_range_pods                        = "admin-pods"
#   ip_range_services                    = "admin-svcs"
#   identity_namespace                   = "${var.fleet_project}.svc.id.goog"
#   release_channel                      = var.release_channel
#   name                                 = "gke-ap-admin-cp-00"
#   region                               = "us-central1"
#   subnetwork                           = "admin-control-plane"
#   network_project_id                   = var.vpc_project_id
#   gateway_api_channel                  = "CHANNEL_STANDARD"
#   grant_registry_access                = true
#   dns_cache                            = true
#   horizontal_pod_autoscaling           = true
#   enable_private_nodes                 = true
#   master_ipv4_cidr_block               = "172.16.100.16/28"
#   depends_on = [ 
#     module.vpc,
#     google_project_service.services,
#     ]
# }

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
  provider = google-beta
  name           = "gke-ap-admin-cp-00"
  project        = var.project_id
  location       = "us-central1"
  enable_autopilot = true
  initial_node_count       = 1
  network                     = "projects/${var.vpc_project_id}/global/networks/${var.vpc_name}"
  subnetwork                  = "projects/${var.vpc_project_id}/regions/us-central1/subnetworks/admin-control-plane"
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
    cluster_secondary_range_name  = "admin-pods"
    services_secondary_range_name = "admin-svcs"
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
    master_ipv4_cidr_block  = "172.16.100.16/28"
    master_global_access_config {
      enabled = true
    }
  }
  release_channel { channel = var.release_channel }
  secret_manager_config { enabled = true }

  security_posture_config {
    mode = "ENTERPRISE"
    vulnerability_mode = "VULNERABILITY_ENTERPRISE"
  }
  depends_on = [ 
    module.vpc,
    google_project_service.services,
    ]
}  
