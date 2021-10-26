/**
 * Copyright 2021 Google LLC
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

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sourcerepo_repository 
// Create 1 centralized Cloud Source Repo, that all GKE clusters will sync to  
resource "google_sourcerepo_repository" "gke-poc-config-sync" {
  name = "gke-poc-config-sync"
}


// enable ACM project-wide
resource "google_gke_hub_feature" "feature" {
  depends_on = [
    module.gke,
  ]
  name     = "configmanagement"
  location = "global"
  project  = module.enabled_google_apis.project_id
  provider = google-beta
}

// Register each cluster to GKE Hub (Fleets API)
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature_membership#configmanagement 
resource "google_gke_hub_membership" "membership" {
  provider = google-beta
  depends_on = [
    module.gke,
  ]

  for_each = var.cluster_config
  project  = module.enabled_google_apis.project_id

  membership_id = "${each.key}-membership"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/projects/${module.enabled_google_apis.project_id}/locations/${each.value.region}/clusters/${each.key}"
    }
  }
}

// If they're enabled, install Config Sync and/or Policy Controller on every cluster 
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature_membership#git 
resource "google_gke_hub_feature_membership" "feature_member" {
  provider = google-beta
  depends_on = [
    module.gke,
    resource.google_gke_hub_membership.membership,
  ]
  
  // TODO - Config Sync does not have its own individual toggle. Policy Controller does. 
  // So here we are installing Config Sync whether the user has it enabled for not. 
  // Attempted to use `count` to do an if-conditional create resource, but you can't use count and for each together. 
  for_each = var.cluster_config
  location   = "global"
  project    = module.enabled_google_apis.project_id
  feature    = "configmanagement"
  membership = "projects/${module.enabled_google_apis.project_id}/locations/global/memberships/${each.key}-membership"
  configmanagement {
    version = "1.9.0"
    config_sync {
      git {
        sync_repo   = google_sourcerepo_repository.gke-poc-config-sync.url
        policy_dir  = "/"
        sync_branch = "main"
        secret_type = "none"
      }
      source_format = "unstructured"
    }
    policy_controller {
      enabled                    = var.policy_controller
      template_library_installed = true
    }
  }
}

