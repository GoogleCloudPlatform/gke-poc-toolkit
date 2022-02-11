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

// Defines vars so that we can pass them in from cluster_build/main.tf from the overall tfvars
variable "cluster_config" {}
variable "vpc_name" {}
variable "vpc_project_id" {}
variable "project_id" {}
variable "asm_version" {}
variable "asm_release_channel" {}
variable "asm_package" {}

locals {
  cluster_count = length(var.cluster_config)
}

// Create Kubeconfig
resource "null_resource" "create_kube_config" {
  for_each = var.cluster_config
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = "scripts/create_kube_config.sh"
    working_dir = path.module
    environment = {
      CLUSTER    = each.key
      LOCATION   = each.value.region
      PROJECT_ID    = var.project_id
      ASM_VERSION = var.asm_version
      ASM_PACKAGE = var.asm_package
    }
  }
}

// Install asm crds on each cluster
resource "null_resource" "install_mesh" {
  for_each = var.cluster_config
  depends_on = [
    null_resource.create_kube_config,
  ]
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = "scripts/install_mesh.sh"
    working_dir = path.module
    environment = {
      CLUSTER    = each.key
      LOCATION   = each.value.region
      PROJECT_ID    = var.project_id
    }
  }
}

// Install asm crds on each cluster
resource "null_resource" "swap_secrets" {
  depends_on = [
    null_resource.install_mesh,
  ]
  for_each = local.cluster_count != 1 ? var.cluster_config : {}
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = "scripts/swap_secrets.sh"
    working_dir = path.module
    environment = {
      CLUSTER     = each.key
      LOCATION    = each.value.region
      PROJECT_ID  = var.project_id
      ASM_VERSION = var.asm_version
      ASM_PACKAGE = var.asm_package
    }
  }
}

# Safer cluster creates the rule below - leaving just in case we decide to change the cluster module and need to implement a FW rule to allow intra-cluster traffic
# module "firewall_rules" {
#   source       = "terraform-google-modules/network/google//modules/firewall-rules"
#   project_id   = var.vpc_project_id
#   network_name = var.vpc_name

#   rules = [{
#     name                    = "allow-all-10"
#     description             = null
#     direction               = "INGRESS"
#     priority                = null
#     ranges                  = ["10.0.0.0/8"]
#     source_tags             = null
#     source_service_accounts = null
#     target_tags             = null
#     target_service_accounts = null
#     allow = [{
#       protocol = "tcp"
#       ports    = ["0-65535"]
#     }]
#     deny = []
#     log_config = {
#       metadata = "INCLUDE_ALL_METADATA"
#     }
#   }]
# }