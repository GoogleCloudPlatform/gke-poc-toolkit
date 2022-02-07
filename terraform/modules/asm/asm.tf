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
  template = file("${path.module}/templates/kubeconfig-template.yaml.tpl")

  vars = {
    context                = local.context
    cluster_ca_certificate = local.cluster_ca_certificate
    endpoint               = local.endpoint
    token                  = local.token
  }
}

data "template_file" "kubeconfig-secret" {
  template = file("${path.module}/templates/kubeconfig-secret-template.yaml.tpl")
  vars = {
    cluster    = var.cluster_name
    kubeconfig = base64encode(data.template_file.kubeconfig.rendered)
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
    }
  }
}

resource "kubernetes_namespace" "ns-istio-system" {
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_manifest" "cpr-asm-managed" {
    depends_on = [
    null_resource.exec_gke_mesh,
  ]
  manifest = {
    apiVersion = "mesh.cloud.google.com/v1alpha1"
    kind       = "ControlPlaneRevision"

    metadata = {
      name      = "asm-managed"
      namespace = kubernetes_namespace.ns-istio-system.metadata[0].name
    }

    spec = {
      type    = "managed_service"
      channel = "regular"
    }
  }
  wait_for = {
    fields = {
      "status.conditions[1].type" = "ProvisioningFinished"
    }
  }
}

resource "kubernetes_service_account" "ksa-istio-reader-sa" {
  metadata {
    name      = "istio-reader-sa"
    namespace = kubernetes_namespace.ns-istio-system.metadata[0].name
  }
}

resource "kubernetes_cluster_role" "clusterole-istio-reader-sa-clusterrole" {
  metadata {
    name = "istio-reader-sa-clusterrole"
    labels = {
      "app"     = "istio-reader"
      "release" = "istio"
    }
  }
  rule {
    api_groups = ["config.istio.io", "security.istio.io", "networking.istio.io", "authentication.istio.io", "apiextensions.k8s.io"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["endpoints", "pods", "services", "nodes", "replicationcontrollers", "namespaces", "secrets"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["replicasets"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
    verbs      = ["create"]
  }
  rule {
    api_groups = ["authorization.k8s.io"]
    resources  = ["subjectaccessreviews"]
    verbs      = ["create"]
  }
}

resource "kubernetes_cluster_role_binding" "clusterolebinding-istio-reader-sa-clusterrolebinding" {
  metadata {
    name = "istio-reader-sa-clusterrolebinding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.clusterole-istio-reader-sa-clusterrole.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.ksa-istio-reader-sa.metadata[0].name
    namespace = kubernetes_service_account.ksa-istio-reader-sa.metadata[0].namespace
  }
}

data "kubernetes_secret" "ksa-secret-istio-reader-sa" {
  metadata {
    name      = kubernetes_service_account.ksa-istio-reader-sa.default_secret_name
    namespace = kubernetes_service_account.ksa-istio-reader-sa.metadata[0].namespace
  }
}