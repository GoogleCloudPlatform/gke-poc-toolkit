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

// Required values to be set in terraform.tfvars
variable "project_id" {
  description = "The project in which to hold the components"
  type        = string
}

variable "region" {
  description = "The region in which to create the VPC network"
  type        = string
}

variable "zone" {
  description = "The zone in which to create the Kubernetes cluster. Must match the region"
  type        = string
}

variable "cluster_name" {
  description = "The name to give the new Kubernetes cluster."
  type        = string
  default     = ""
}

variable "service_account_iam_roles" {
  type = list

  default = [
    "roles/storage.objectCreator"
  ]
  description = <<-EOF
  List of the IAM roles to attach to the Workload Identity service account for use with GCS.
  EOF
}

variable "project_services" {
  type = list

  default = [
    "storage.googleapis.com",
    "iap.googleapis.com",

  ]
  description = <<-EOF
  The GCP APIs that should be enabled in this project.
  EOF
}

variable "governance_project_id" {
  description = "The project to use for governance resources such as kvm and log sinks"
  type        = string
}

variable "k8s_namespace" {
  description = "Kubernetes Namespace to be created"
  type        = string
  default     = "storage-application"
}
variable "k8s_sa_name" {
  description = "Kubernetes service account for Workload Identity"
  type        = string
  default     = "storage-service-account"

}

variable "k8s_users"{
  type = map(string)
  default = { 
    rbac-demo-auditor = "view"
    rbac-demo-editor = "edit"
    }
}
