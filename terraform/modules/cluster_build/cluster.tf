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

module "gke" {
  depends_on = [
    module.bastion,
    module.kms,
  ]
  for_each                = var.cluster_config
  source                  = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version                 = "19.0.0"
  project_id              = module.enabled_google_apis.project_id
  name                    = each.key
  region                  = each.value.region
  release_channel         = var.release_channel
  config_connector        = var.config_connector
  network                 = local.network_name
  subnetwork              = each.value.subnet_name
  network_project_id      = local.project_id
  ip_range_pods           = local.ip_range_pods
  ip_range_services       = local.ip_range_services
  enable_private_endpoint = var.private_endpoint
  grant_registry_access   = true
  enable_shielded_nodes   = true
  master_ipv4_cidr_block  = "172.16.${index(keys(var.cluster_config), each.key)}.16/28"
  master_authorized_networks = [{
    cidr_block   = var.private_endpoint ? "${module.bastion[0].ip_address}/32" : "${var.auth_cidr}"
    display_name = var.private_endpoint ? "Bastion Host" : "Workstation Public IP"
  }]

  compute_engine_service_account = local.gke_service_account_email
  database_encryption = [{
    state    = "ENCRYPTED"
    key_name = "projects/${var.governance_project_id}/locations/${each.value.region}/keyRings/${local.gke_keyring_name}-${each.value.region}/cryptoKeys/${local.gke_key_name}"
  }]

  node_pools = local.cluster_node_pool

  node_pools_oauth_scopes = {
    (var.node_pool) = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    # all = {} default set in terraform-google-kubernetes-engine

    default-node-pool = {
      default-node-pool = false
    }
  }

  node_pools_metadata = {
    # all = {} default set in terraform-google-kubernetes-engine

    (var.node_pool) = {
      // Set metadata on the VM to supply more entropy
      google-compute-enable-virtio-rng = "true"
      // Explicitly remove GCE legacy metadata API endpoint
      disable-legacy-endpoints = "true"
    }
  }
}

// Add optional Windows Node Pool
module "windows_nodepool" {
  depends_on = [
    module.gke,
  ]
  count              = var.windows_nodepool ? 1 : 0
  source             = "../windows_nodepool"
  cluster_config     = var.cluster_config
  name               = format("windows-%s", var.node_pool)
  project_id         = var.project_id
  initial_node_count = var.initial_node_count
  min_count          = var.min_node_count
  max_count          = var.max_node_count
  disk_size_gb       = 100
  disk_type          = "pd-ssd"
  image_type         = "WINDOWS_SAC"
  machine_type       = var.windows_machine_type
  service_account    = local.gke_service_account_email
  // Intergrity Monitoring is not enabled in Windows Node pools yet.
  enable_integrity_monitoring = false
  enable_secure_boot          = true
}

// Bind the KCC operator Kubernetes service account(KSA) to the 
// KCC Google Service account(GSA) so the KSA can assume the workload identity users role.
module "service_account-iam-bindings" {
  depends_on = [
    module.gke,
  ]
  source = "terraform-google-modules/iam/google//modules/service_accounts_iam"

  service_accounts = [local.kcc_service_account_email]
  project          = module.enabled_google_apis.project_id
  bindings = {
    "roles/iam.workloadIdentityUser" = [
      "serviceAccount:${module.enabled_google_apis.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]",
    ]
  }
}
