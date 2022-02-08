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
variable "project_id" {}
variable "location" {}
variable "asm_release_channel" {}
variable "use_private_endpoint" {
  description = "Connect on the private GKE cluster endpoint"
  type        = bool
  default     = false
}

// Locals

locals {
  cluster_ca_certificate = data.google_container_cluster.gke_cluster.master_auth != null ? data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate : ""
  private_endpoint       = try(data.google_container_cluster.gke_cluster.private_cluster_config[0].private_endpoint, "")
  default_endpoint       = data.google_container_cluster.gke_cluster.endpoint != null ? data.google_container_cluster.gke_cluster.endpoint : ""
  endpoint               = var.use_private_endpoint == true ? local.private_endpoint : local.default_endpoint
  host                   = local.endpoint != "" ? "https://${local.endpoint}" : ""
  context                = data.google_container_cluster.gke_cluster.name != null ? data.google_container_cluster.gke_cluster.name : ""
  token                  = lookup(data.kubernetes_secret.ksa-secret-istio-reader-sa.data, "token")
}

// Data Resources
data "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.location
  project  = var.project_id
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/templates/kubeconf-template.yaml.tpl")

  vars = {
    context                = local.context
    cluster_ca_certificate = local.cluster_ca_certificate
    endpoint               = local.endpoint
    token                  = local.token
  }
}

data "template_file" "kubeconfig-secret" {
  template = file("${path.module}/templates/kubeconf-secret-template.yaml.tpl")
  vars = {
    cluster    = var.cluster_name
    kubeconfig = base64encode(data.template_file.kubeconfig.rendered)
  }
}

data "template_file" "asm-control-plane-revision" {
  template = file("${path.module}/templates/asm-control-plane-revision.yaml.tpl")
  vars = {
    asm_release_channel    = var.asm_release_channel
  }
}

// Install asm crds on each cluster
resource "null_resource" "exec_gke_mesh" {
#   for_each = var.cluster_config
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = "${path.module}/scripts/install_crds.sh"
    environment = {
      CLUSTER    = var.cluster_name
      LOCATION   = var.location
      PROJECT_ID    = var.project_id
      KSA_SECRET = data.template_file.kubeconfig-secret.rendered
      ASM_RELEASE_CHANNEL = data.template_file.asm-control-plane-revision.rendered
    }
  }
}

data "kubernetes_secret" "ksa-secret-istio-reader-sa" {
  metadata {
    name      = kubernetes_service_account.ksa-istio-reader-sa.default_secret_name
    namespace = kubernetes_service_account.ksa-istio-reader-sa.metadata[0].namespace
  }
}