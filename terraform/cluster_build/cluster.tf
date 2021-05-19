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
  source                  = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version                 = "14.0.1"
  project_id              = module.enabled_google_apis.project_id
  name                    = var.cluster_name
  region                  = var.region
  config_connector        = var.config_connector
  network                 = local.network_name
  subnetwork              = local.subnetwork_name
  network_project_id      = local.project_id
  ip_range_pods           = local.ip_range_pods
  ip_range_services       = local.ip_range_services
  enable_private_endpoint = var.private_endpoint
  enable_shielded_nodes   = true
  master_ipv4_cidr_block  = "172.16.0.16/28"
  master_authorized_networks = [{
    cidr_block   = var.private_endpoint ? "${module.bastion[0].ip_address}/32" : "${var.auth_ip}/32"
    display_name = var.private_endpoint ? "Bastion Host" : "Workstation Public IP"
  }]

  compute_engine_service_account = local.gke_service_account_email
  database_encryption = [{
    state    = "ENCRYPTED"
    key_name = local.database-encryption-key
  }]

  node_pools = local.cluster_node_pools

  node_pools_oauth_scopes = {
    all = []
    (var.node_pool) = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = false
    }
  }

  node_pools_metadata = {
    all = {}

    (var.node_pool) = {
      // Set metadata on the VM to supply more entropy
      google-compute-enable-virtio-rng = "true"
      // Explicitly remove GCE legacy metadata API endpoint
      disable-legacy-endpoints = "true"
    }
  }
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

    # "roles/iam.serviceAccountCreator" = [
    #   "serviceAccount:${module.enabled_google_apis.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]",
    # ]
  }
}
