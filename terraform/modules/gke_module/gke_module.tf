module "gke" {
  for_each                = var.cluster_config
  source                  = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version                 = "25.0.0"
  project_id              = var.project_id
  network                 = var.network
  ip_range_pods           = var.ip_range_pods
  ip_range_services       = var.ip_range_services
  release_channel         = var.release_channel
  initial_node_count      = var.initial_node_count
  name                    = each.key
  regional                = var.regional_clusters
  region                  = each.value.region
  zones                   = each.value.zones
  config_connector        = var.config_connector
  subnetwork              = each.value.subnet_name
  network_project_id      = var.network_project_id
  enable_private_endpoint = var.private_endpoint
  gateway_api_channel     = "CHANNEL_STANDARD"
  grant_registry_access   = true
  enable_shielded_nodes   = true
  master_ipv4_cidr_block  = "172.16.${index(keys(var.cluster_config), each.key)}.16/28"
  master_authorized_networks = [{
    cidr_block   = var.auth_cidr
    display_name = "Workstation Public IP"
  }]

  compute_engine_service_account = var.gke_service_account_email
  database_encryption = [{
    state    = "ENCRYPTED"
    key_name = "projects/${var.governance_project_id}/locations/${each.value.region}/keyRings/${var.gke_keyring_name}-${each.value.region}/cryptoKeys/${var.gke_key_name}"
  }]

  node_pools = var.cluster_node_pool

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
  cluster_resource_labels = var.asm_label
}