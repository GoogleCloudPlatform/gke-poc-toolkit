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

module "enabled_shared_vpc_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 10.0"

  project_id                  = var.shared_vpc_project_id
  disable_services_on_destroy = false

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]
}

module "shared_vpc_networkuser" {
  depends_on = [
    module.service_accounts,
  ]
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 3.0"
  project_id = var.shared_vpc_project_id
  names      = [local.ce_service_account]
  project_roles = [
    "${var.project_id}=>roles/compute.networkUser",
    "${var.project_id}=>roles/container.hostServiceAgentUser",
  ]
}

resource "google_compute_shared_vpc_service_project" "attach_toolkit" {
  depends_on = [
    module.shared_vpc_networkuser,
  ]
  host_project    = var.shared_vpc_project_id
  service_project = var.project_id
}
