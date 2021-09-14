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
  count            = var.shared_vpc ? 0 : 1
  source           = "terraform-google-modules/network/google"
  version          = "~> 2.5"

  project_id       = module.enabled_google_apis.project_id
  network_name     = var.vpc_name
  routing_mode     = "GLOBAL"

  subnets          = local.nested_subnets

  secondary_ranges = local.nested_secondary_subnets
}

module "cluster-nat" {
  depends_on = [
    module.vpc,
  ]
  source                             = "terraform-google-modules/cloud-nat/google"
  create_router                      = true
  project_id                         = local.project_id
  region                             = var.region
  router                             = "${var.project_id}-private-cluster-router"
  network                            = local.vpc_selflink
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetworks                        = local.subnetworks_to_nat
}

data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  EOF
}

module "bastion" {
  depends_on = [
    module.vpc,
  ]
  count          = var.private_endpoint ? 1 : 0
  source         = "terraform-google-modules/bastion-host/google"
  version        = "~> 3.2"
  network        = local.vpc_selflink
  subnet         = local.bastion_subnet_selflink
  project        = module.enabled_google_apis.project_id
  host_project   = local.project_id
  name           = local.bastion_name
  zone           = local.bastion_zone
  image_project  = "debian-cloud"
  image_family   = "debian-10"
  machine_type   = "g1-small"
  startup_script = data.template_file.startup_script.rendered
  members        = local.bastion_members
  shielded_vm    = "true"
}

