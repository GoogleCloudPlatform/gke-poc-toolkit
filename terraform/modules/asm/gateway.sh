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

resource "kubernetes_namespace" "ns-istio-system" {
  metadata {
    name = "istio-system"
  }
}



resource "kubernetes_manifest" "cpr-asm-managed" {
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

# resource "kubernetes_namespace" "ns-asm-gateways" {
#   metadata {
#     labels = {
#       "istio.io/rev" = "asm-managed"
#     }
#     name = "asm-gateways"
#   }
# }

# resource "kubernetes_service" "asm_ingressgateway" {
#   metadata {
#     name      = "asm-ingressgateway"
#     namespace = kubernetes_namespace.ns-asm-gateways.metadata[0].name
#   }

#   spec {
#     port {
#       name = "http"
#       port = 80
#     }

#     port {
#       name = "https"
#       port = 443
#     }

#     selector = {
#       asm = "ingressgateway"
#     }
#     type = "ClusterIP"
#   }
#   depends_on = [kubernetes_manifest.cpr-asm-managed]
# }

# resource "kubernetes_deployment" "asm_ingressgateway" {
#   metadata {
#     name      = "asm-ingressgateway"
#     namespace = kubernetes_namespace.ns-asm-gateways.metadata[0].name
#   }

#   spec {
#     selector {
#       match_labels = {
#         asm = "ingressgateway"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           asm = "ingressgateway"
#         }

#         annotations = {
#           "inject.istio.io/templates" = "gateway"
#         }
#       }

#       spec {
#         container {
#           name  = "istio-proxy"
#           image = "auto"
#         }
#       }
#     }
#   }
#   depends_on = [kubernetes_manifest.cpr-asm-managed]
# }

# resource "kubernetes_role" "asm_ingressgateway_sds" {
#   metadata {
#     name      = "asm-ingressgateway-sds"
#     namespace = kubernetes_namespace.ns-asm-gateways.metadata[0].name
#   }

#   rule {
#     verbs      = ["get", "watch", "list"]
#     api_groups = [""]
#     resources  = ["secrets"]
#   }
# }

# resource "kubernetes_role_binding" "asm_ingressgateway_sds" {
#   metadata {
#     name      = "asm-ingressgateway-sds"
#     namespace = kubernetes_namespace.ns-asm-gateways.metadata[0].name
#   }

#   subject {
#     kind = "ServiceAccount"
#     name = "default"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = kubernetes_role.asm_ingressgateway_sds.metadata[0].name
#   }
# }