// Defines vars so that we can pass them in from cluster_build/cluster.tf from the overall tfvars
variable "cluster_ids" {
}

variable "name" {
}

variable "min_count" {
}

variable "max_count" {
}

variable "disk_size_gb" {
}

variable "disk_type" {
}

variable "image_type" {
}

variable "machine_type" {
}

variable "initial_node_count" {
}

variable "enable_integrity_monitoring" {
}

variable "enable_secure_boot" {
}


// Add Windows Node Pool to each GKE cluster created
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool 
# resource "google_container_cluster" "primary" {
#   for_each           = var.cluster_ids
#   name               = "marcellus-wallace"
#   location           = "us-central1-a"
#   initial_node_count = 3

#   node_locations = [
#     "us-central1-c",
#   ]

#   node_config {
#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     service_account = google_service_account.default.email
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#     guest_accelerator {
#       type  = "nvidia-tesla-k80"
#       count = 1
#     }
#   }
# }

  # // Presets for Windows Node Pool
  # windows_pool = [{
  #   name               = format("windows-%s", var.node_pool)
  #   min_count          = var.min_node_count
  #   max_count          = var.max_node_count
  #   disk_size_gb       = 100
  #   disk_type          = "pd-ssd"
  #   image_type         = "WINDOWS_SAC"
  #   machine_type       = var.windows_machine_type
  #   initial_node_count = var.initial_node_count
  #   // Intergrity Monitoring is not enabled in Windows Node pools yet.
  #   enable_integrity_monitoring = false
  #   enable_secure_boot          = true
  # }]


