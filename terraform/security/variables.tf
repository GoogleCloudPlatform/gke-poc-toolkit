// Required values to be set in terraform.tfvars
variable "project" {
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
    "iap.googleapis.com"

  ]
  description = <<-EOF
  The GCP APIs that should be enabled in this project.
  EOF
}

variable "log_project" {
  description = "The project to use for log sinks"
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
