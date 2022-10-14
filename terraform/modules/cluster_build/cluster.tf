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

// GKE Module using safer clusters
module "gke_module" {
  depends_on = [
    module.kms,
    module.enabled_google_apis,
    module.enabled_governance_apis,
  ]
  count                     = var.gke_module_bypass ? 0 : 1
  source                    = "../gke_module"
  project_id                = var.project_id
  governance_project_id     = var.governance_project_id
  cluster_config            = var.cluster_config
  network                   = local.network_name
  ip_range_pods             = local.ip_range_pods
  ip_range_services         = local.ip_range_services
  release_channel           = var.release_channel
  gke_keyring_name          = local.gke_keyring_name
  gke_key_name              = local.gke_key_name
  node_pool                 = var.node_pool
  initial_node_count        = var.initial_node_count
  regional_clusters         = var.regional_clusters
  config_connector          = var.config_connector
  network_project_id        = local.project_id
  private_endpoint          = var.private_endpoint
  auth_cidr                 = var.auth_cidr
  gke_service_account_email = local.gke_service_account_email
  cluster_node_pool         = local.cluster_node_pool
  asm_label                 = local.asm_label
}

// Experiments bypassing GKE Module and use GKE resource directly 
module "gke" {
  depends_on = [
    module.kms,
    module.enabled_google_apis,
    module.enabled_governance_apis,
  ]
  count                     = var.gke_module_bypass ? 1 : 0
  source                    = "../gke"
  project_id                = var.project_id
  governance_project_id     = var.governance_project_id
  cluster_config            = var.cluster_config
  network                   = local.network
  ip_range_pods             = local.ip_range_pods
  ip_range_services         = local.ip_range_services
  release_channel           = var.release_channel
  gke_keyring_name          = local.gke_keyring_name
  gke_key_name              = local.gke_key_name
  node_pool                 = var.node_pool
  initial_node_count        = var.initial_node_count
  regional_clusters         = var.regional_clusters
  min_node_count            = var.min_node_count
  max_node_count            = var.max_node_count
  linux_machine_type        = var.linux_machine_type
  windows_machine_type      = var.windows_machine_type
  private_endpoint          = var.private_endpoint
  auth_cidr                 = var.auth_cidr
  windows_nodepool          = var.windows_nodepool
  preemptible_nodes         = var.preemptible_nodes
  gke_service_account_email = local.gke_service_account_email
  asm_label                 = local.asm_label
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
