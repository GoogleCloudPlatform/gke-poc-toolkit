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

// Data Resources
data "google_project" "project" {
  project_id = module.enabled_google_apis.project_id
}

// Random string used to create a unique key ring name
resource "random_id" "deployment" {
  byte_length = 2
}

locals {
  // Presets for project and network settings
  project_id               = var.shared_vpc ? var.vpc_project_id : module.enabled_google_apis.project_id
  network_name             = var.vpc_name
  network                  = "projects/${local.project_id}/global/networks/${var.vpc_name}"
  vpc_selflink             = format("projects/%s/global/networks/%s", local.project_id, local.network_name)
  ip_range_pods            = var.shared_vpc ? var.vpc_ip_range_pods_name : var.ip_range_pods_name
  ip_range_services        = var.shared_vpc ? var.vpc_ip_range_services_name : var.ip_range_services_name
  distinct_cluster_regions = toset([for cluster in var.cluster_config : "${cluster.region}"])

  // Presets for KMS and Key Ring
  gke_keyring_name = format("gke-toolkit-kr-%s", random_id.deployment.hex)
  gke_key_name     = "gke-toolkit-kek"

  // Dynamically create subnet and secondary subnet inputs for multi-cluster creation
  nested_subnets = flatten([
    for name, config in var.cluster_config : [
      {
        subnet_name           = config.subnet_name
        subnet_ip             = "10.0.${index(keys(var.cluster_config), name)}.0/24"
        subnet_region         = config.region
        subnet_private_access = true
        description           = "This subnet is managed by Terraform"
      }
    ]
  ])

  nested_secondary_subnets = {
    for name, config in var.cluster_config : config.subnet_name => [
      {
        range_name    = local.ip_range_pods
        ip_cidr_range = "10.${index(keys(var.cluster_config), name) + 1}.0.0/17"
      },
      {
        range_name    = local.ip_range_services
        ip_cidr_range = "10.${index(keys(var.cluster_config), name) + 1}.128.0/17"
      }
    ]
  }

  # subnetworks_to_nat = flatten([ for cluster in var.cluster_config : [{ "name" = cluster.subnet_name, "source_ip_ranges_to_nat" = ["PRIMARY_IP_RANGE"], "secondary_ip_range_names" = [] }] ])

  // Presets for Sevice Account
  gke_service_account       = "gke-toolkit-sa"
  gke_service_account_email = "${local.gke_service_account}@${module.enabled_google_apis.project_id}.iam.gserviceaccount.com"
  clu_service_account       = format("service-%s@container-engine-robot.iam.gserviceaccount.com", data.google_project.project.number)
  prj_service_account       = format("%s@cloudservices.gserviceaccount.com", data.google_project.project.number)
  kcc_service_account       = "gke-toolkit-kcc"
  kcc_service_account_email = "${local.kcc_service_account}@${module.enabled_google_apis.project_id}.iam.gserviceaccount.com"

  // Presets for Service Account permissions
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

  // Presets for Linux Node Pool
  linux_pool = [{
    name               = format("linux-%s", var.node_pool)
    initial_node_count = var.initial_node_count
    min_count          = var.min_node_count
    max_count          = var.max_node_count
    auto_upgrade       = true
    auto_repair        = true
    node_metadata      = "GKE_METADATA"
    machine_type       = var.linux_machine_type
    disk_type          = "pd-balanced"
    disk_size_gb       = 30
    image_type         = "COS_CONTAINERD"
    preemptible        = var.preemptible_nodes ? true : false
    enable_secure_boot = true
  }]

  // Final Node Pool options for Cluster - combines all specified nodepools
  cluster_node_pool = flatten(local.linux_pool)

  // These locals are used to construct anthos component depends on rules based on which features are enabled
  acm_depends_on     = var.anthos_service_mesh ? module.asm : (var.multi_cluster_gateway ? module.mcg : module.hub)
  asm_depends_on     = var.multi_cluster_gateway ? module.mcg : module.hub
  gke_hub_depends_on = var.gke_module_bypass ? module.gke : module.gke_module

  // Labels to apply to the cluster - Needed for to enable the ASM UI
  asm_label = var.anthos_service_mesh ? {
    mesh_id = format("proj-%s", data.google_project.project.number)
  } : {}
}

// Enable APIs needed in the gke cluster project
module "enabled_google_apis" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 17.0"
  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "iam.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "containerregistry.googleapis.com",
    "container.googleapis.com",
    "binaryauthorization.googleapis.com",
    "stackdriver.googleapis.com",
    "iap.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "dns.googleapis.com",
    "iamcredentials.googleapis.com",
    "stackdriver.googleapis.com",
    "cloudkms.googleapis.com",
  ]
}

// Enable Anthos APIs in gke cluster project 
module "enabled_anthos_apis" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 17.0"
  count                       = var.multi_cluster_gateway || var.config_sync || var.anthos_service_mesh ? 1 : 0
  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "iam.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "containerregistry.googleapis.com",
    "container.googleapis.com",
    "binaryauthorization.googleapis.com",
    "stackdriver.googleapis.com",
    "iap.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "dns.googleapis.com",
    "iamcredentials.googleapis.com",
    "stackdriver.googleapis.com",
    "anthos.googleapis.com",
    "gkehub.googleapis.com",
    "sourcerepo.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "anthos.googleapis.com",
    "gkehub.googleapis.com",
    "multiclusterservicediscovery.googleapis.com",
    "multiclusteringress.googleapis.com",
    "trafficdirector.googleapis.com",
    "mesh.googleapis.com",
    "multiclustermetering.googleapis.com",
    "cloudkms.googleapis.com",
    "multiclustermetering.googleapis.com",
  ]
}

// Enable APIs needed in the governance project
module "enabled_governance_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 17.0"

  project_id                  = var.governance_project_id
  disable_services_on_destroy = false

  activate_apis = [
    "cloudkms.googleapis.com",
  ]
}

// Create the KMS keyring and owner 
module "kms" {
  depends_on = [
    module.service_accounts,
    module.enabled_governance_apis,
  ]
  for_each        = local.distinct_cluster_regions
  source          = "terraform-google-modules/kms/google"
  version         = "~> 3.0"
  project_id      = var.governance_project_id
  location        = each.key
  keyring         = "${local.gke_keyring_name}-${each.key}"
  keys            = [local.gke_key_name]
  set_owners_for  = [local.gke_key_name]
  prevent_destroy = false
  owners = [
    "serviceAccount:${local.clu_service_account}",
  ]
}

module "hub" {
  depends_on = [
    local.gke_hub_depends_on,
    module.enabled_anthos_apis,
  ]
  count             = var.multi_cluster_gateway || var.config_sync || var.anthos_service_mesh ? 1 : 0
  source            = "../hub"
  project_id        = var.project_id
  cluster_config    = var.cluster_config
  regional_clusters = var.regional_clusters
}

module "acm" {
  depends_on = [
    local.acm_depends_on,
    module.enabled_anthos_apis,
  ]
  count             = var.config_sync ? 1 : 0
  config_sync_repo  = var.config_sync_repo
  source            = "../acm"
  project_id        = var.project_id
  policy_controller = var.policy_controller
  cluster_config    = var.cluster_config
  email             = data.google_client_openid_userinfo.me.email
}

module "mcg" {
  depends_on = [
    module.hub,
    module.enabled_anthos_apis,
  ]
  count          = var.multi_cluster_gateway ? 1 : 0
  source         = "../mcg"
  project_id     = var.project_id
  cluster_config = var.cluster_config
  vpc_project_id = var.vpc_project_id
  vpc_name       = var.vpc_name
}

module "asm" {
  depends_on = [
    local.asm_depends_on,
    module.enabled_anthos_apis,

  ]
  count          = var.anthos_service_mesh ? 1 : 0
  source         = "../asm"
  project_id     = var.project_id
  cluster_config = var.cluster_config
}
