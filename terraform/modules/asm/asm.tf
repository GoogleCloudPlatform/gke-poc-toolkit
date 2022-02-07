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
variable "project_id" {}
# variable "location" {}
# variable "use_private_endpoint" {
#   description = "Connect on the private GKE cluster endpoint"
#   type        = bool
#   default     = false
# }


# // Data Resources
# data "google_container_cluster" "gke_cluster" {
#   name     = var.cluster_name
#   location = var.location
#   project  = var.project_id
# }

# data "template_file" "kubeconfig" {
#   template = file("${path.module}/templates/kubeconfig-template.yaml.tpl")

#   vars = {
#     context                = local.context
#     cluster_ca_certificate = local.cluster_ca_certificate
#     endpoint               = local.endpoint
#     token                  = local.token
#   }
# }

# data "template_file" "kubeconfig-secret" {
#   template = file("${path.module}/templates/kubeconfig-secret-template.yaml.tpl")
#   vars = {
#     cluster    = var.cluster_name
#     kubeconfig = base64encode(data.template_file.kubeconfig.rendered)
#   }
# }

// Install gateway api crds on each cluster
resource "null_resource" "exec_gke_mesh" {
#   for_each = var.cluster_config
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = "${path.module}/scripts/install_crds.sh"
    environment = {
      CLUSTER    = each.key
      LOCATION   = each.value.region
      PROJECT_ID    = var.project_id
    }
  }
}














