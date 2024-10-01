/**
 * Copyright 2024 Google LLC
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

# Create Hub Service Account
resource "google_project_iam_member" "hubsa" {
  project = var.fleet_project
  role    = "roles/gkehub.serviceAgent"
  member  = local.hub_service_account
  depends_on = [
    module.enabled_service_project_apis,
  ]
}

# Fleet Policy Defaults
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

  depends_on = [module.enabled_service_project_apis]
}

# Config Sync Defaults
resource "google_gke_hub_feature" "config_management" {
  name     = "configmanagement"
  project  = var.fleet_project
  location = "global"
  provider = google

  fleet_default_member_config {
    configmanagement {
      # Use the default latest version
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

  depends_on = [module.enabled_service_project_apis]
}

# Mesh Config Defaults
resource "google_gke_hub_feature" "mesh_config_defaults" {
  project  = var.fleet_project
  location = "global"
  name     = "servicemesh"

  fleet_default_member_config {
    mesh {
      management = "MANAGEMENT_AUTOMATIC"
    }
  }

  depends_on = [google_project_iam_member.hubsa]
}

# Fleet Observability
resource "google_gke_hub_feature" "fleet_observability" {
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

  depends_on = [module.enabled_service_project_apis]
}

# Fleet Resource
resource "google_gke_hub_fleet" "default" {
  project = var.fleet_project

  default_cluster_config {
    security_posture_config {
      mode               = "BASIC"
      vulnerability_mode = "VULNERABILITY_BASIC"
    }
  }

  depends_on = [module.enabled_service_project_apis]
}
