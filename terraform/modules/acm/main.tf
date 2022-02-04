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
}

// create ACM service account 
module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = var.project_id
  display_name  = "ACM service account"
  names         = [local.acm_service_account]
  project_roles = ["${var.project_id}=>roles/source.reader"]
}

module "service_account-iam-bindings" {
  depends_on = [
    resource.google_gke_hub_feature_membership.feature_member,
  ]
  source = "terraform-google-modules/iam/google//modules/service_accounts_iam"

  service_accounts = [local.acm_service_account_email]
  project          = var.project_id
  bindings = {
    "roles/iam.workloadIdentityUser" = [
      "serviceAccount:${var.project_id}.svc.id.goog[config-management-system/root-reconciler]",
    ]
  }
}


// enable ACM project-wide
resource "google_gke_hub_feature" "feature" {
  name     = "configmanagement"
  location = "global"
  project  = var.project_id
  provider = google-beta
}

// Register each cluster to GKE Hub (Fleets API)
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature_membership#configmanagement 
resource "google_gke_hub_membership" "membership" {
  provider = google-beta
  for_each = var.cluster_config
  project  = var.project_id

  membership_id = "${each.key}-membership"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/projects/${var.project_id}/locations/${each.value.region}/clusters/${each.key}"
    }
  }
}

// install config sync
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature_membership#git 
resource "google_gke_hub_feature_membership" "feature_member" {
  provider = google-beta
  depends_on = [
    resource.google_gke_hub_membership.membership,
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
