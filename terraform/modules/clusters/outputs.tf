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

output "project_id" {
  description = "Deployment project ID"
  value       = var.project_id
}

output "get_credential_commands" {
  description = "gcloud get-credentials command to generate kubeconfig for the private cluster"
  value       = flatten([for s in google_container_cluster.gke_ap : (format("gcloud container fleet memberships get-credentials %s --project %s --location=%s", s.name, var.project_id, s.location))])
}

output "cluster_names" {
  description = "List of GKE cluster names"
  value       = flatten([for s in google_container_cluster.gke_ap : s.name])
}

output "endpoints" {
  sensitive   = true
  description = "List of GKE cluster endpoints"
  value       = flatten([for s in google_container_cluster.gke_ap : s.endpoint])
}
