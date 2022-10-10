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
variable "cluster_config" {}
variable "project_id" {}

resource "google_gke_hub_feature" "mesh" {
  name     = "servicemesh"
  project  = var.project_id
  location = "global"
  provider = google-beta
}

// Install asm crds on each cluster
resource "null_resource" "install_mesh" {
  for_each = var.cluster_config
  depends_on = [
    google_gke_hub_feature.mesh,
  ]
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = "scripts/install_mesh.sh"
    working_dir = path.module
    environment = {
      CLUSTER    = each.key
      LOCATION   = each.value.region
      PROJECT_ID = var.project_id
    }
  }
}