data "google_project" "cluster-project" {
  project_id = var.fleet_project
}

data "google_project" "fleet-project" {
  project_id = var.fleet_project
}

data "google_project" "vpc-project" {
  project_id = var.vpc_project_id
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