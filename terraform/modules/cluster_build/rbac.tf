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

// Create the service accounts for GKE and KCC from a map declared in locals.
module "service_accounts" {
  for_each = local.service_accounts
  depends_on = [
    module.enabled_google_apis,
    module.enabled_governance_apis,
  ]
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 4.4.0"
  project_id    = module.enabled_google_apis.project_id
  display_name  = "${each.key} service account"
  names         = [each.key]
  project_roles = each.value
  generate_keys = true
}

// Bind the KCC operator Kubernetes service account(KSA) to the 
// KCC Google Service account(GSA) so the KSA can assume the workload identity users role.
module "service_account-iam-bindings" {
  depends_on = [
    local.gke_hub_depends_on,
  ]
  count  = var.config_connector ? 1 : 0
  source = "terraform-google-modules/iam/google//modules/service_accounts_iam"

  service_accounts = [local.kcc_service_account_email]
  project          = module.enabled_google_apis.project_id
  bindings = {
    "roles/iam.workloadIdentityUser" = [
      "serviceAccount:${module.enabled_google_apis.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]",
    ]
  }
}

module "rbac_service_accounts" {
  for_each   = var.k8s_users
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.4.0"
  project_id = var.project_id
  names      = [each.key]
  project_roles = [
    "${var.project_id}=>roles/container.clusterViewer",
    "${var.project_id}=>roles/container.viewer"
  ]
  generate_keys = true
}

resource "local_file" "service_account_key" {
  for_each = module.rbac_service_accounts
  filename = "../creds/${each.value.email}.json"
  content  = each.value.key
}