variable "project_id" {
}

variable "cluster_config" {
}

// Grant gkehub default service account permissions to register clusters to the Fleet
module "service_account-iam-bindings" {
  source = "terraform-google-modules/iam/google//modules/service_accounts_iam"

  service_accounts = "service-${var.project_id}@gcp-sa-gkehub.iam.gserviceaccount.com"
  project          = var.project_id
  bindings = {
    "roles/gkehub.serviceAgent" = [
      "service-${var.project_id}@gcp-sa-gkehub.iam.gserviceaccount.com",
    ]
  }
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
  authority {
    issuer = "https://container.googleapis.com/v1/projects/${var.project_id}/locations/${each.value.region}/clusters/${each.key}"
  }
}