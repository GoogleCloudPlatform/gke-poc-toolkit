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

// Performs necessary steps to attach service project to Shared VPC host project
// Modules and resources below do not get executed if SHARED_VPC=false

resource "google_compute_subnetwork_iam_binding" "subnet_networkuser" {
  depends_on = [
    module.shared_vpc
  ]
  for_each   = var.cluster_config
  project    = var.vpc_project_id
  region     = each.value.region
  subnetwork = each.value.subnet_name
  role       = "roles/compute.networkUser"
  members = [
    "serviceAccount:${local.clu_service_account}",
    "serviceAccount:${local.prj_service_account}",
  ]
}

resource "google_project_iam_binding" "shared_vpc_serviceagent" {
  depends_on = [
    google_compute_subnetwork_iam_binding.subnet_networkuser
  ]
  role    = "roles/container.hostServiceAgentUser"
  project = var.vpc_project_id
  members = [
    "serviceAccount:${local.clu_service_account}",
  ]
}

resource "google_compute_shared_vpc_service_project" "attach_toolkit" {
  depends_on = [
    google_compute_subnetwork_iam_binding.subnet_networkuser,
    google_project_iam_binding.shared_vpc_serviceagent,
  ]
  host_project    = var.vpc_project_id
  service_project = var.project_id
}
