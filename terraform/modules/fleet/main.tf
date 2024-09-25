data "google_project" "cluster-project" {
  project_id = var.fleet_project
}

data "google_project" "fleet-project" {
  project_id = var.fleet_project
}

data "google_project" "vpc-project" {
  project_id = var.vpc_project_id
}

locals {
  // Presets for Service Accounts
  clu_service_account = format("service-%s@container-engine-robot.iam.gserviceaccount.com", data.google_project.cluster-project.number)
  prj_service_account = format("%s@cloudservices.gserviceaccount.com", data.google_project.cluster-project.number)
  gke_service_account       = "gke-toolkit-sa"
  gke_service_account_email = "${local.gke_service_account}@${var.project_id}.iam.gserviceaccount.com"
  
  // Presets for Service Account permissions
  service_accounts = {
    (local.gke_service_account) = [
      "${module.enabled_service_project_apis.project_id}=>roles/artifactregistry.reader",
      "${module.enabled_service_project_apis.project_id}=>roles/logging.logWriter",
      "${module.enabled_service_project_apis.project_id}=>roles/monitoring.metricWriter",
      "${module.enabled_service_project_apis.project_id}=>roles/monitoring.viewer",
      "${module.enabled_service_project_apis.project_id}=>roles/stackdriver.resourceMetadata.writer",
      "${module.enabled_service_project_apis.project_id}=>roles/storage.objectViewer",
    ]
  }
  vpc_selflink             = format("projects/%s/global/networks/%s", var.project_id, var.vpc_name)
  distinct_cluster_regions = toset([for cluster in var.cluster_config : "${cluster.region}"])
// Dynamically create subnet and secondary subnet inputs for multi-cluster creation
  admin_subnet = flatten([
    {
      subnet_name           = "admin-control-plane"
      subnet_ip             = "10.0.100.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
      description           = "This subnet is for the admin control plane and is managed by Terraform"
    }
  ])
  nested_subnets_raw = flatten([
    for name, config in var.cluster_config  : [
      {
        subnet_name           = config.subnet_name
        subnet_ip             = "10.0.${index(keys(var.cluster_config), name)}.0/24"
        subnet_region         = config.region
        subnet_private_access = true
        description           = "This subnet is managed by Terraform"
      }
    ]
  ])
  
  nested_subnets = concat(local.admin_subnet, local.nested_subnets_raw)
  
  admin_secondary_subnets = {
    "admin-control-plane" = [
      {
        range_name    = "admin-pods"
        ip_cidr_range = "10.101.0.0/17"
      },
      {
        range_name    = "admin-svcs"
        ip_cidr_range = "10.103.0.0/17"
      }
    ]
  }
    
  nested_secondary_subnets = merge(local.admin_secondary_subnets,{
    for name, config in var.cluster_config : config.subnet_name => [
      {
        range_name    = var.vpc_ip_range_pods_name
        ip_cidr_range = "10.${index(keys(var.cluster_config), name) + 1}.0.0/17"
      },
      {
        range_name    = var.vpc_ip_range_services_name
        ip_cidr_range = "10.${index(keys(var.cluster_config), name) + 1}.128.0/17"
      },
    ]
  })
}

module "enabled_service_project_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 17.0"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
  ]
}

// policy defaults
resource "google_gke_hub_feature" "fleet_policy_defaults" {
  project  = var.fleet_project
  location = "global"
  name     = "policycontroller"

  fleet_default_member_config {
    policycontroller {
      policy_controller_hub_config {
        install_spec = "INSTALL_SPEC_ENABLED"
        policy_content {
          bundles {
            bundle = "cis-k8s-v1.5.1"
          }
        }
        audit_interval_seconds    = 30
        referential_rules_enabled = true
      }
    }
  }
  depends_on = [
    google_project_service.services
  ]
}

// Create the service accounts from a map declared in locals.
module "service_account" {
  for_each = local.service_accounts
  depends_on = [
    module.enabled_service_project_apis,
  ]
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 4.0"
  project_id    = module.enabled_service_project_apis.project_id
  display_name  = "${each.key} service account"
  names         = [each.key]
  project_roles = each.value
}

// config sync defaults
resource "google_gke_hub_feature" "feature" {
  name     = "configmanagement"
  project  = var.fleet_project
  location = "global"
  provider = google
  fleet_default_member_config {
    configmanagement {
      # version = "1.17.0" # Use the default latest version; if specifying a version, it must be at or after 1.17.0
      config_sync {
        source_format = "unstructured"
        git {
          sync_repo   = var.config_sync_repo
          sync_branch = var.config_sync_repo_branch
          policy_dir  = var.config_sync_repo_dir
          secret_type = "none"
        }
      }
    }
  }
  depends_on = [
    google_project_service.services
  ]
}

// mesh defaults
resource "google_gke_hub_feature" "mesh_config_defaults" {
  project  = var.fleet_project
  location = "global"
  name     = "servicemesh"
  fleet_default_member_config {
    mesh {
      management = "MANAGEMENT_AUTOMATIC"
    }
  }

  depends_on = [
    google_project_service.services
  ]
}

// the fleet observeability feature for log management
resource "google_gke_hub_feature" "fleetobservability" {
  name     = "fleetobservability"
  project  = var.fleet_project
  location = "global"
  spec {
    fleetobservability {
      logging_config {
        default_config {
          mode = "COPY"
        }
        fleet_scope_logs_config {
          mode = "COPY"
        }
      }
    }
  }

  depends_on = [
    google_project_service.services
  ]
}


// cluster managed capabilities are managed in the fleet resource
resource "google_gke_hub_fleet" "default" {
  project = var.fleet_project
  default_cluster_config {
    security_posture_config {
      mode               = "BASIC"
      vulnerability_mode = "VULNERABILITY_BASIC"
    }
  }

  depends_on = [
    google_project_service.services
  ]
}