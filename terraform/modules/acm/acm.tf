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
 
// Defines vars so that we can pass them in from cluster_build/main.tf from the overall tfvars
variable "project_id" {
}

variable "policy_controller" {
}

variable "cluster_config" {
}

variable "email" {
}

locals {
  acm_service_account       = "acm-service-account"
  acm_service_account_email = "${local.acm_service_account}@${var.project_id}.iam.gserviceaccount.com"
}

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sourcerepo_repository 
// Create 1 centralized Cloud Source Repo, that all GKE clusters will sync to  
resource "google_sourcerepo_repository" "gke-poc-config-sync" {
  name = "gke-poc-config-sync"    
  project  = var.project_id
}

// enable ACM project-wide
resource "google_gke_hub_feature" "acm" {
  name = "configmanagement"
  location = "global"
  project  = var.project_id
  provider = google-beta
}

// install config sync
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature_membership#git 
resource "google_gke_hub_feature_membership" "feature_member" {
  provider = google-beta
  depends_on = [
    resource.google_gke_hub_feature.acm,
  ]
  // https://cloud.google.com/anthos-config-management/docs/how-to/installing-config-sync#gcloud 
  for_each   = var.cluster_config
  location   = "global"
  project    = var.project_id
  feature    = "configmanagement"
  membership = "projects/${var.project_id}/locations/global/memberships/${each.key}-membership"
  configmanagement {
    version = "1.10.1"
    config_sync {
      git {
        sync_repo   = "https://source.developers.google.com/p/${var.project_id}/r/gke-poc-config-sync"
        policy_dir  = "/"
        sync_branch = "main"
        secret_type = "gcpserviceaccount"
        gcp_service_account_email = local.acm_service_account_email
      }
      source_format = "unstructured"
    }
    policy_controller {
      enabled                    = var.policy_controller
      template_library_installed = var.policy_controller
    }
  }
}
