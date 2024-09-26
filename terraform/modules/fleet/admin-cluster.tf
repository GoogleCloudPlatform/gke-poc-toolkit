
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
  name           = "gke-ap-admin-cp-00"
  project        = var.project_id
  location       = "us-central1"
  # node_locations = "us-central1-c"
  
  fleet {
    project = var.fleet_project
  }

  cost_management_config {
    enabled = true
  }

  enable_autopilot = true
  network                     = var.vpc_name
  subnetwork                  = "admin-control-plane"
  networking_mode             = "VPC_NATIVE"
  # enable_intranode_visibility = true
  datapath_provider           = "ADVANCED_DATAPATH"
  dns_config {
    cluster_dns = "CLOUD_DNS"
    cluster_dns_scope = "CLUSTER_SCOPE"
  }

  release_channel {
    channel = var.release_channel
  }

  security_posture_config {
    mode = "ENTERPRISE"
    vulnerability_mode = "VULNERABILITY_ENTERPRISE"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "admin-pods"
    services_secondary_range_name = "admin-svcs"
  }
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS", "APISERVER", "CONTROLLER_MANAGER", "SCHEDULER"]
  }
  monitoring_config {
    managed_prometheus { enabled = true }
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS", "APISERVER", "CONTROLLER_MANAGER", "SCHEDULER", "STORAGE", "HPA", "POD", "DAEMONSET", "DEPLOYMENT", "STATEFULSET", "KUBELET", "CADVISOR", "DCGM"]
  }

  node_config {
    gcfs_config { enabled = true }
  }
  cluster_autoscaling {
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
  }
  workload_identity_config {
    workload_pool = "${var.fleet_project}.svc.id.goog"
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.100.16/28"
    master_global_access_config {
      enabled = true
    }
  }
  # master_authorized_networks_config {
  #   cidr_blocks {
  #     cidr_block   = var.auth_cidr
  #     display_name = "Workstation Public IP"
  #   }
  # }
  # remove_default_node_pool = true
  initial_node_count       = 12
  addons_config {
    # network_policy_config { disabled = false }
    # gcp_filestore_csi_driver_config { enabled = true }
    gcs_fuse_csi_driver_config { enabled = true }
    # dns_cache_config { enabled = true }
    gce_persistent_disk_csi_driver_config { enabled = true }
    gke_backup_agent_config { enabled = true }
  }
  secret_manager_config { enabled = true }
  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }
}

# resource "google_container_node_pool" "primary_nodes" {
#   depends_on = [
#     resource.google_container_cluster.primary
#   ]
#   for_each           = var.cluster_config
#   name               = format("linux-%s", var.node_pool)
#   project            = var.project_id
#   location           = var.regional_clusters ? each.value.region : each.value.zones[0]
#   cluster            = each.key
#   node_locations     = each.value.zones
#   initial_node_count = var.initial_node_count
#   autoscaling {
#     total_min_node_count = var.min_node_count
#     total_max_node_count = var.max_node_count
#     location_policy = "ANY"
#   }
#   management {
#     auto_upgrade = true
#     auto_repair  = true
#   }
#   node_config {
#     preemptible  = var.preemptible_nodes ? true : false
#     machine_type = var.linux_machine_type
#     image_type   = "COS_CONTAINERD"
#     disk_type    = "pd-ssd"
#     disk_size_gb = 200
#     shielded_instance_config {
#       enable_secure_boot          = true
#       enable_integrity_monitoring = true
#     }

#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     service_account = local.gke_service_account_email
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform",
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#     ]
  # }
# }