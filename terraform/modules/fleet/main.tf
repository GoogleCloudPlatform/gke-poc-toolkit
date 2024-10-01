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

data "google_project" "cluster_project" {
  project_id = var.project_id
}

data "google_project" "fleet_project" {
  project_id = var.fleet_project
}

data "google_project" "vpc_project" {
  project_id = var.vpc_project_id
}

locals {
  # VPC Self-link
  vpc_selflink = format("projects/%s/global/networks/%s", var.project_id, var.vpc_name)

  # Distinct cluster regions
  distinct_cluster_regions = toset([for cluster in var.cluster_config : cluster.region])

  # Subnet configurations
  admin_subnet = flatten([
    {
      subnet_name           = "admin-control-plane"
      subnet_ip             = "10.0.100.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
      description           = "This subnet is for the admin control plane and is managed by Terraform"
    }
  ])
  nested_subnets_raw = flatten([
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

  nested_subnets = concat(local.admin_subnet, local.nested_subnets_raw)

  admin_secondary_subnets = {
    "admin-control-plane" = [
      {
        range_name    = "admin-pods"
        ip_cidr_range = "10.101.0.0/17"
      },
      {
        range_name    = "admin-svcs"
        ip_cidr_range = "10.103.0.0/17"
      }
    ]
  }

  nested_secondary_subnets = merge(local.admin_secondary_subnets, {
    for name, config in var.cluster_config : config.subnet_name => [
      {
        range_name    = var.vpc_ip_range_pods_name
        ip_cidr_range = "10.${index(keys(var.cluster_config), name) + 1}.0.0/17"
      },
      {
        range_name    = var.vpc_ip_range_services_name
        ip_cidr_range = "10.${index(keys(var.cluster_config), name) + 1}.128.0/17"
      },
    ]
  })

  # Hub service account
  hub_service_account_email = format("service-%s@gcp-sa-gkehub.iam.gserviceaccount.com", data.google_project.fleet_project.number)
  hub_service_account       = "serviceAccount:${local.hub_service_account_email}"
}