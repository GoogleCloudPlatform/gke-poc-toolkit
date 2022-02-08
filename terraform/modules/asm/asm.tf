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
variable "cluster_name" {}
variable "cluster_config" {  }
variable "project_id" {}
variable "location" {}
variable "asm_version" {}
variable "asm_release_channel" {}

// Install asm crds on each cluster
resource "null_resource" "exec_gke_mesh" {
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = "${path.module}/scripts/install_mesh.sh"
    environment = {
      MODULE_PATH = path.module
      CLUSTER    = var.cluster_name
      LOCATION   = var.location
      PROJECT_ID    = var.project_id
    }
  }
}

// Install asm crds on each cluster
resource "null_resource" "exec_secrets_mesh" {
  depends_on = [
    null_resource.exec_gke_mesh,
  ]
  for_each = var.cluster_config
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = "${path.module}/scripts/export_svcs.sh"
    environment = {
      MODULE_PATH = path.module
      CLUSTER    = var.cluster_name
      LOCATION   = var.location
      TARGET_CLUSTER    = each.key
      TARGET_LOCATION   = each.value.region
      PROJECT_ID    = var.project_id
      ASM_VERSION = var.asm_version
      ASM_RELEASE_CHANNEL = data.template_file.asm-control-plane-revision.rendered
    }
  }
}