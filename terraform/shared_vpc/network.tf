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
  version = "~> 2.5"

  project_id   = var.shared_vpc_project_id
  network_name = var.shared_vpc_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = var.shared_vpc_subnet_name
      subnet_ip             = var.shared_vpc_subnet_ip
      subnet_region         = var.region
      subnet_private_access = true
      description           = "This subnet is managed by Terraform"
    }
  ]
  secondary_ranges = {
    (var.shared_vpc_subnet_name) = [
      {
        range_name    = var.shared_vpc_ip_range_pods_name
        ip_cidr_range = "10.10.64.0/18"
      },
      {
        range_name    = var.shared_vpc_ip_range_services_name
        ip_cidr_range = "10.10.192.0/18"
      },
    ]
  }
}

resource "google_compute_shared_vpc_host_project" "host_project" {
  depends_on = [
    module.shared_vpc,
  ]
  project = var.shared_vpc_project_id
}