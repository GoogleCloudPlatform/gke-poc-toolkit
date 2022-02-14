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

// Create GCS Bucket in Governance Project 
resource "google_storage_bucket" "log-bucket" {
  name                        = "gke-logging-bucket-${random_id.deployment.hex}"
  storage_class               = "NEARLINE"
  force_destroy               = true
  project                     = var.governance_project_id
  uniform_bucket_level_access = true
  location                    = var.region
}

// Create BQ Data Set in Governance Project
resource "google_bigquery_dataset" "bigquery-dataset" {
  dataset_id = "gke_logs_dataset"
  # location                    = "US" dfeault set in terraform-google-bigquery
  default_table_expiration_ms = 3600000
  project                     = var.governance_project_id
  labels = {
    env = "default"
  }
  delete_contents_on_destroy = true
}

// Create Log Sink in GKE Cluster Project
resource "google_logging_project_sink" "storage-sink" {
  name                   = "gke-storage-sink"
  destination            = "storage.googleapis.com/${google_storage_bucket.log-bucket.id}"
  filter                 = "resource.type=(k8s_cluster OR gke_cluster) AND log_id(cloudaudit.googleapis.com/activity)"
  project                = var.project_id
  unique_writer_identity = true
}

// Create Big Query Sink
resource "google_logging_project_sink" "bigquery-sink" {
  depends_on = [
    resource.google_bigquery_dataset.bigquery-dataset
  ]
  name        = "gke-bigquery-sink"
  destination = "bigquery.googleapis.com/${google_bigquery_dataset.bigquery-dataset.id}"
  filter      = "resource.type=(k8s_cluster OR gke_cluster) AND log_id(cloudaudit.googleapis.com/activity)"
  project     = var.project_id

  unique_writer_identity = true
}

// Add IAM permission in Logging project for Service accounts from GKE Project
resource "google_project_iam_binding" "log-writer-storage" {
  role    = "roles/storage.objectCreator"
  project = var.governance_project_id
  members = [
    google_logging_project_sink.storage-sink.writer_identity,
  ]
}
// Add IAM permission in Logging project for Service accounts from GKE Project
resource "google_project_iam_binding" "log-writer-bigquery" {
  role    = "roles/bigquery.dataEditor"
  project = var.governance_project_id
  members = [
    google_logging_project_sink.bigquery-sink.writer_identity,
  ]
}

