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
  vpc_selflink             = format("projects/%s/global/networks/%s", local.project_id, local.network_name)
  ip_range_pods            = var.shared_vpc ? var.vpc_ip_range_pods_name : var.ip_range_pods_name
  ip_range_services        = var.shared_vpc ? var.vpc_ip_range_services_name : var.ip_range_services_name
  distinct_cluster_regions = toset([for cluster in var.cluster_config : "${cluster.region}"])

  // Presets for KMS and Key Ring
  gke_keyring_name = format("gke-toolkit-kr-%s", random_id.deployment.hex)
  gke_key_name     = "gke-toolkit-kek"

  // Presets for Bastion Host
  default_subnetwork_name   = lookup(var.cluster_config, element(keys(var.cluster_config), 0), "").subnet_name
  default_subnetwork_region = lookup(var.cluster_config, element(keys(var.cluster_config), 0), "").region
  bastion_name              = "gke-tk-bastion"
  bastion_subnet_selflink   = format("projects/%s/regions/%s/subnetworks/%s", local.project_id, local.default_subnetwork_region, local.default_subnetwork_name)
  bastion_zone              = format("%s-b", local.default_subnetwork_region)
  bastion_members = [
    format("user:%s", data.google_client_openid_userinfo.me.email),
  ]

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
    node_metadata      = "GKE_METADATA"
    machine_type       = var.linux_machine_type
    disk_type          = "pd-ssd"
    disk_size_gb       = 30
    image_type         = "COS"
    preemptible        = var.preemptible_nodes ? true : false
    enable_secure_boot = true
  }]

  // Final Node Pool options for Cluster - combines all specified nodepools
  cluster_node_pool = flatten(local.linux_pool)
}

// Enable APIs needed in the gke cluster project
module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.3.1"

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
    "sourcerepo.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "anthos.googleapis.com",
    "gkehub.googleapis.com",
    "multiclusterservicediscovery.googleapis.com",
    "multiclusteringress.googleapis.com",
    "trafficdirector.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "dns.googleapis.com",
    "meshca.googleapis.com",
    "meshtelemetry.googleapis.com",
    "meshconfig.googleapis.com",
    "iamcredentials.googleapis.com",
    "stackdriver.googleapis.com"
  ]
}

// Enable APIs needed in the governance project
module "enabled_governance_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.3.1"

  project_id                  = var.governance_project_id
  disable_services_on_destroy = false

  activate_apis = [
    "cloudkms.googleapis.com",
  ]
}

// Create the service accounts for GKE and KCC from a map declared in locals.
module "service_accounts" {
  for_each      = local.service_accounts
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 4.1.0"
  project_id    = module.enabled_google_apis.project_id
  display_name  = "${each.key} service account"
  names         = [each.key]
  project_roles = each.value
  generate_keys = true
}

// Create the KMS keyring and owner 
module "kms" {
  depends_on = [
    module.service_accounts,
  ]
  for_each        = local.distinct_cluster_regions
  source          = "terraform-google-modules/kms/google"
  version         = "~> 2.1.0"
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
    module.gke,
  ]
  count          = var.multi_cluster_gateway || var.config_sync ? 1 : 0
  source         = "../hub"
  project_id     = var.project_id
  cluster_config = var.cluster_config
}

module "acm" {
  depends_on = [
    module.hub,
  ]
  count             = var.config_sync ? 1 : 0
  source            = "../acm"
  project_id        = var.project_id
  policy_controller = var.policy_controller
  cluster_config    = var.cluster_config
  email             = data.google_client_openid_userinfo.me.email
}

module "mcg" {
  depends_on = [
    module.acm,
  ]
  count                 = var.multi_cluster_gateway ? 1 : 0
  source                = "../mcg"
  project_id            = var.project_id
  cluster_config        = var.cluster_config
  vpc_project_id        = var.vpc_project_id
  vpc_name              = var.vpc_name
}

module "asm" {
  depends_on = [
    module.mcg,
  ]
  count                 = var.anthos_service_mesh ? 1 : 0
  source                = "../asm"
  project_id            = var.project_id
  cluster_config        = var.cluster_config
  vpc_project_id        = var.vpc_project_id
  vpc_name              = var.vpc_name  
  asm_version = var.asm_version
  asm_release_channel   = var.asm_release_channel
  asm_package = var.asm_package
}
