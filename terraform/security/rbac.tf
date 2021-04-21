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

module "service_accounts" {
  for_each      = var.k8s_users
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = var.project
  names         = [each.key]
  project_roles = [
    "${var.project}=>roles/container.clusterViewer",
    "${var.project}=>roles/container.viewer"
  ]
  generate_keys = true
}


resource "local_file" "service_account_key" {
  for_each =  module.service_accounts
  filename = "../../creds/${each.value.email}.json"
  content  = each.value.key
}


resource "kubernetes_cluster_role_binding" "auditor" {
  for_each  = var.k8s_users
  metadata {
    name      = each.key
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = each.value
  }
  subject {
    kind      = "User"
    name      = format("%s@%s.iam.gserviceaccount.com", each.key, var.project)
    api_group = "rbac.authorization.k8s.io"
  }
}