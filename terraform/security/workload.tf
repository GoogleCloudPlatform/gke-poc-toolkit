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

data "google_container_cluster" "cluster" {
  name     = var.cluster_name
  project  = var.project
  location = var.region
}

// Create the GKE service account
resource "google_service_account" "gke-wi-sa" {
  account_id   = format("%s-wi-sa", var.cluster_name)
  display_name = "GKE Workload Identity Service Account"
  project      = var.project
}

data "google_iam_policy" "access_gcs" {
  binding {
    role = "roles/iam.workloadIdentityUser"

    members = [
      format("serviceAccount:%s.svc.id.goog[%s/%s]", var.project, var.k8s_namespace, var.k8s_sa_name)
    ]
  }
}
resource "google_service_account_iam_policy" "access_gcs" {
  service_account_id = google_service_account.gke-wi-sa.name
  policy_data        = data.google_iam_policy.access_gcs.policy_data
}
resource "google_project_iam_binding" "access_gcs" {
  project = var.project
  role    = "roles/iam.workloadIdentityUser"

  members = [
    format("serviceAccount:%s", google_service_account.gke-wi-sa.email)
  ]
}
// Create GCS Bucket in for Workload Identity Use 
resource "google_storage_bucket" "wi-bucket" {
  name          = "gke-application-bucket-${random_id.server.hex}"
  storage_class = "NEARLINE"
  force_destroy = true
  project       = var.project
}

resource "kubernetes_namespace" "application" {
  metadata {
    name = var.k8s_namespace
  }
}

resource "kubernetes_service_account" "storage-sa" {
  metadata {
    name      = var.k8s_sa_name
    namespace = var.k8s_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = format("serviceAccount:%s", google_service_account.gke-wi-sa.email)
    }
  }
  depends_on = [
    kubernetes_namespace.application,
  ]
}

resource "kubernetes_deployment" "gcs-wi-test" {
  metadata {
    name      = "gcs-wi-test"
    namespace = var.k8s_namespace
    labels = {
      app = "demo"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "demo"
      }
    }
    template {
      metadata {
        labels = {
          app = "demo"
        }
      }
      spec {
        service_account_name = var.k8s_sa_name
        container {
          image = "debricked/example-gke-workload-identity-app:latest"
          name  = "gcs-fuse-workload"
          port {
            container_port = "8080"
          }
          env {
            name  = "PORT"
            value = "8080"

          }
          env {
            name  = "BUCKET_NAME"
            value = google_storage_bucket.wi-bucket.name
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }

          }
        }
      }
    }
  }
}


resource "kubernetes_deployment" "gcs-wi-test-bad" {
  metadata {
    name      = "gcs-wi-test-bad"
    namespace = var.k8s_namespace
    labels = {
      app = "demo"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "demo"
      }
    }
    template {
      metadata {
        labels = {
          app = "demo"
        }
      }
      spec {

        container {
          image = "debricked/example-gke-workload-identity-app:latest"
          name  = "gcs-fuse-workload"
          port {
            container_port = "8080"
          }
          env {
            name  = "PORT"
            value = "8080"

          }
          env {
            name  = "BUCKET_NAME"
            value = google_storage_bucket.wi-bucket.name
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }

          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example" {
  metadata {
    name      = "gcs-wi-test-lb"
    namespace = var.k8s_namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.gcs-wi-test.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}