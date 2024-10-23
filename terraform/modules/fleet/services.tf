/**
 * Copyright 2024 Google LLC
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

# Enable Fleet Services
module "enabled_service_project_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 17.0"

  project_id                  = var.fleet_project
  disable_services_on_destroy = false

  activate_apis = [
    "container.googleapis.com",
    "anthos.googleapis.com",
    "dns.googleapis.com",
    "gkehub.googleapis.com",
    "gkeconnect.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "anthospolicycontroller.googleapis.com",
    "meshconfig.googleapis.com",
    "meshca.googleapis.com",
    "containersecurity.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "multiclusterservicediscovery.googleapis.com",
    "multiclusteringress.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "sourcerepo.googleapis.com",
    "endpoints.googleapis.com",
    "certificatemanager.googleapis.com",
  ]
}