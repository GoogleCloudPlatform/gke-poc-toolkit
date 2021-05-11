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

// Enable APIs needed in the gke cluster project
module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 10.0"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "iam.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "containerregistry.googleapis.com",
    "container.googleapis.com",
    "binaryauthorization.googleapis.com",
    "stackdriver.googleapis.com",
    "iap.googleapis.com",
  ]
}

// Enable APIs needed in the governance project
module "enabled_governance_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 10.0"

  project_id                  = var.governance_project_id
  disable_services_on_destroy = false

  activate_apis = [
    "cloudkms.googleapis.com",
  ]
}

data "google_project" "project" {
  project_id = module.enabled_google_apis.project_id
}

// Random string used to create a unique key ring name
resource "random_id" "kms" {
  byte_length = 2
}

// Locals used to construct names of stuffs.
locals {
  kcc_service_account       = format("%s-kcc", var.cluster_name)
  kcc_service_account_email = "${local.kcc_service_account}@${module.enabled_google_apis.project_id}.iam.gserviceaccount.com"
  bastion_name              = format("%s-bastion", var.cluster_name)
  gke_service_account       = format("%s-sa", var.cluster_name)
  gke_service_account_email = "${local.gke_service_account}@${module.enabled_google_apis.project_id}.iam.gserviceaccount.com"
  gke_keyring_name          = format("%s-kr-%s", var.cluster_name, random_id.kms.hex)
  gke_key_name              = format("%s-kek", var.cluster_name)
  kek_service_account       = format("service-%s@container-engine-robot.iam.gserviceaccount.com", data.google_project.project.number)
  database-encryption-key   = "projects/${var.governance_project_id}/locations/${var.region}/keyRings/${local.gke_keyring_name}/cryptoKeys/${local.gke_key_name}"
  bastion_zone              = var.zone
  bastion_members = [
    format("user:%s", data.google_client_openid_userinfo.me.email),
  ]
  service_accounts = {
    (local.gke_service_account) = [
      "${module.enabled_google_apis.project_id}=>roles/artifactregistry.reader",
      "${module.enabled_google_apis.project_id}=>roles/logging.logWriter",
      "${module.enabled_google_apis.project_id}=>roles/monitoring.metricWriter",
      "${module.enabled_google_apis.project_id}=>roles/monitoring.viewer",
      "${module.enabled_google_apis.project_id}=>roles/stackdriver.resourceMetadata.writer",
      "${module.enabled_google_apis.project_id}=>roles/storage.objectViewer",
    ]
    (local.kcc_service_account) = [
      "${module.enabled_google_apis.project_id}=>roles/owner",
      "${module.enabled_google_apis.project_id}=>roles/iam.serviceAccountCreator",
    ]
  }
  windows_pool = [
    {
      name          = format("linux-%s", var.node_pool)
      min_count     = 1
      max_count     = 10
      auto_upgrade  = true
      node_metadata = "GKE_METADATA_SERVER"
      machine_type  = "n1-standard-2"
      disk_type     = "pd-ssd"
      disk_size_gb  = 30
      image_type    = "COS"
    },
    {
      name               = format("windows-%s", var.node_pool)
      min_count          = 0
      max_count          = 10
      disk_size_gb       = 100
      disk_type          = "pd-ssd"
      image_type         = "WINDOWS_SAC"
      initial_node_count = 0
      // Intergrity Monitoring is not enabled in Windows Node pools yet.
      enable_integrity_monitoring = false
    }
  ]
  linux_pool = [{
    name          = format("linux-%s", var.node_pool)
    min_count     = 1
    max_count     = 10
    auto_upgrade  = true
    node_metadata = "GKE_METADATA_SERVER"
    machine_type  = "n1-standard-2"
    disk_type     = "pd-ssd"
    disk_size_gb  = 30
    image_type    = "COS"
    },
  ]
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 2.5"

  project_id   = module.enabled_google_apis.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = var.subnet_name
      subnet_ip             = var.subnet_ip
      subnet_region         = var.region
      subnet_private_access = true
      description           = "This subnet is managed by Terraform"
    }
  ]
  secondary_ranges = {
    (var.subnet_name) = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.10.64.0/18"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.10.192.0/18"
      },
    ]
  }
}

module "cluster-nat" {
  source        = "terraform-google-modules/cloud-nat/google"
  project_id    = module.enabled_google_apis.project_id
  region        = var.region
  router        = "private-cluster-router"
  network       = module.vpc.network_self_link
  create_router = true
}

data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  EOF
}

module "bastion" {
  source         = "terraform-google-modules/bastion-host/google"
  version        = "~> 3.1"
  network        = module.vpc.network_self_link
  subnet         = module.vpc.subnets_self_links[0]
  project        = module.enabled_google_apis.project_id
  host_project   = module.enabled_google_apis.project_id
  name           = local.bastion_name
  zone           = local.bastion_zone
  image_project  = "debian-cloud"
  image_family   = "debian-9"
  machine_type   = "g1-small"
  startup_script = data.template_file.startup_script.rendered
  members        = local.bastion_members
  shielded_vm    = "false"
  count          = var.private_endpoint ? 1 : 0
}

// Create the service accounts for GKE and KCC from a map declared in locals.
module "service_accounts" {
  for_each      = local.service_accounts
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = module.enabled_google_apis.project_id
  display_name  = "${each.key} service account"
  names         = [each.key]
  project_roles = each.value
  generate_keys = true
}

module "kms" {
  depends_on = [
    module.service_accounts,
  ]
  source         = "terraform-google-modules/kms/google"
  version        = "~> 2.0"
  project_id     = var.governance_project_id
  location       = var.region
  keyring        = local.gke_keyring_name
  keys           = [local.gke_key_name]
  set_owners_for = [local.gke_key_name]
  owners = [
    "serviceAccount:${local.kek_service_account}",
  ]
}

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
  network                 = module.vpc.network_name
  subnetwork              = module.vpc.subnets_names[0]
  ip_range_pods           = module.vpc.subnets_secondary_ranges[0].*.range_name[0]
  ip_range_services       = module.vpc.subnets_secondary_ranges[0].*.range_name[1]
  enable_private_endpoint = var.private_endpoint
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

  node_pools = var.windows_nodepool == "true" ? local.windows_pool : local.linux_pool

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
