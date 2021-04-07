// Create GCS Bucket in Logging Project 
resource "google_storage_bucket" "log-bucket" {
  name          = "gke-logging-bucket-${random_id.server.hex}"
  storage_class = "NEARLINE"
  force_destroy = true
  project       = var.log_project
}

//Create BQ Data Set in Logging Project
resource "google_bigquery_dataset" "bigquery-dataset" {
  dataset_id                  = "gke_logs_dataset"
  location                    = "US"
  default_table_expiration_ms = 3600000
  project                     = var.log_project
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
  project                = var.project
  unique_writer_identity = true
}
// Create Big Query Sink
resource "google_logging_project_sink" "bigquery-sink" {
  name        = "gke-bigquery-sink"
  destination = "bigquery.googleapis.com/${google_bigquery_dataset.bigquery-dataset.id}"
  filter      = "resource.type=(k8s_cluster OR gke_cluster) AND log_id(cloudaudit.googleapis.com/activity)"
  project     = var.project

  unique_writer_identity = true
}

// Add IAM permission in Logging project for Service accounts from GKE Project
resource "google_project_iam_binding" "log-writer-storage" {
  role    = "roles/storage.objectCreator"
  project = var.log_project
  members = [
    google_logging_project_sink.storage-sink.writer_identity,
  ]
}
// Add IAM permission in Logging project for Service accounts from GKE Project
resource "google_project_iam_binding" "log-writer-bigquery" {
  role    = "roles/bigquery.dataEditor"
  project = var.log_project
  members = [
    google_logging_project_sink.bigquery-sink.writer_identity,
  ]
}

