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

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.gke.endpoint
}


output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.gke.ca_certificate
}


output "get_credentials_command" {
  description = "gcloud get-credentials command to generate kubeconfig for the private cluster"
  value       = (var.private_endpoint ? (format("gcloud container clusters get-credentials --project %s --zone %s --internal-ip %s", var.project_id, module.gke.location, module.gke.name)) : (format("gcloud container clusters get-credentials --project %s --zone %s %s", var.project_id, module.gke.location, module.gke.name)))
}
output "bastion_name" {
 description = "Name of the bastion host"
 value       = (var.private_endpoint ? module.bastion[0].hostname : "")
}
output "bastion_ssh_command" {
  description = "gcloud command to ssh and port forward to the bastion host command"
  value       = (var.private_endpoint ? (format("gcloud beta compute ssh %s --tunnel-through-iap --project %s --zone %s -- -L8888:127.0.0.1:8888", module.bastion[0].hostname, var.project_id, local.bastion_zone)) : "")
}

output "bastion_kubectl_command" {
  description = "kubectl command using the local proxy once the bastion_ssh command is running"
  value       = (var.private_endpoint ? "HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces": "kubectl get pods --all-namespaces")

}
