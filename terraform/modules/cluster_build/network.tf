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

module "vpc" {
  count   = var.shared_vpc ? 0 : 1
  source  = "terraform-google-modules/network/google"
  version = "~> 6.0.1"

  project_id   = module.enabled_google_apis.project_id
  network_name = var.vpc_name
  routing_mode = "GLOBAL"

  subnets = local.nested_subnets

  secondary_ranges = local.nested_secondary_subnets
}

module "cluster-nat" {
  depends_on = [
    module.vpc,
  ]
  for_each                           = local.distinct_cluster_regions
  version                            = "~> 2.2.2"
  source                             = "terraform-google-modules/cloud-nat/google"
  create_router                      = true
  project_id                         = local.project_id
  region                             = each.key
  router                             = "gke-toolkit-rtr-${each.key}"
  network                            = local.vpc_selflink
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"
}

data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  EOF
}