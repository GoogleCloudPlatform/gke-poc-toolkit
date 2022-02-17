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

module "shared_vpc" {
  depends_on = [
    module.enabled_shared_vpc_apis,
    module.enabled_service_project_apis
  ]
  source  = "terraform-google-modules/network/google"
  version = "~> 4.1.0"

  project_id   = var.vpc_project_id
  network_name = var.vpc_name
  # routing_mode = "GLOBAL" default in terraform-google-network

  subnets = local.nested_subnets

  secondary_ranges = local.nested_secondary_subnets
}

resource "google_compute_shared_vpc_host_project" "host_project" {
  depends_on = [
    module.shared_vpc,
  ]
  project = var.vpc_project_id
}