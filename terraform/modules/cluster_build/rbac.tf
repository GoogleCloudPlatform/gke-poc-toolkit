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

module "rbac_service_accounts" {
  for_each   = var.k8s_users
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.1.0"
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