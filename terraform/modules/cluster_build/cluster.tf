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

// GKE Module using private clusters
module "gke" {
  for_each                             = var.cluster_config
  deletion_protection                  = false
  source                               = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                              = "~>33.0.4"
  authenticator_security_group         = var.authenticator_security_group
  cluster_dns_provider                 = "CLOUD_DNS"
  cluster_dns_scope                    = "CLUSTER_SCOPE"
  datapath_provider                    = "ADVANCED_DATAPATH"
  enable_cost_allocation               = true
  enable_intranode_visibility          = true
  enable_private_endpoint              = true
  filestore_csi_driver                 = true
  gce_pd_csi_driver                    = true
  gke_backup_agent_config              = true
  monitoring_enable_managed_prometheus = true
  project_id                           = var.project_id
  fleet_project                        = var.fleet_project
  network                              = var.vpc_name
  ip_range_pods                        = var.vpc_ip_range_pods_name
  ip_range_services                    = var.vpc_ip_range_services_name
  release_channel                      = var.release_channel
  initial_node_count                   = var.initial_node_count
  name                                 = each.key
  regional                             = var.regional_clusters
  region                               = each.value.region
  zones                                = each.value.zones
  subnetwork                           = each.value.subnet_name
  network_project_id                   = var.vpc_project_id
  gateway_api_channel                  = "CHANNEL_STANDARD"
  grant_registry_access                = true
  enable_shielded_nodes                = true
  master_ipv4_cidr_block               = "172.16.${index(keys(var.cluster_config), each.key)}.16/28"
  master_authorized_networks = [{
    cidr_block   = var.auth_cidr
    display_name = "Workstation Public IP"
  }]

  service_account = local.gke_service_account_email

  node_pools = local.cluster_node_pool
  remove_default_node_pool = true
  node_pools_oauth_scopes = {
    (var.node_pool) = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_metadata = {
    (var.node_pool) = {
      // Set metadata on the VM to supply more entropy
      google-compute-enable-virtio-rng = "true"
      // Explicitly remove GCE legacy metadata API endpoint
      disable-legacy-endpoints = "true"
    }
  }
}
