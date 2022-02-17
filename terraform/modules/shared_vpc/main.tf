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

// Data Resources
data "google_project" "project" {
  project_id = var.project_id
}

// Locals used to construct names of stuffs.
locals {
  // Presets for Service Accounts
  clu_service_account = format("service-%s@container-engine-robot.iam.gserviceaccount.com", data.google_project.project.number)
  prj_service_account = format("%s@cloudservices.gserviceaccount.com", data.google_project.project.number)

  // Dynamically create subnet and secondary subnet inputs for multi-cluster creation
  nested_subnets = flatten([
    for name, config in var.cluster_config : [
      {
        subnet_name           = config.subnet_name
        subnet_ip             = "10.0.${index(keys(var.cluster_config), name)}.0/24"
        subnet_region         = config.region
        subnet_private_access = true
        description           = "This subnet is managed by Terraform"
      }
    ]
  ])

  nested_secondary_subnets = {
    for name, config in var.cluster_config : config.subnet_name => [
      {
        range_name    = var.vpc_ip_range_pods_name
        ip_cidr_range = "10.${index(keys(var.cluster_config), name) + 1}.0.0/17"
      },
      {
        range_name    = var.vpc_ip_range_services_name
        ip_cidr_range = "10.${index(keys(var.cluster_config), name) + 1}.128.0/17"
      }
    ]
  }
}

module "enabled_shared_vpc_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.3.1"

  project_id                  = var.vpc_project_id
  disable_services_on_destroy = true

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
  ]
}

module "enabled_service_project_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.3.1"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]
}