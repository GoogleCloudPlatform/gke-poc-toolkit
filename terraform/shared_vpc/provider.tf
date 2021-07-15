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

terraform {
  required_providers {
    google = {
      version = "~> 3.63.0"
    }
    google-beta = {
      version = "~> 3.49.0"
    }
    kubernetes = {
      version = " ~> 1.10"
    }
  }
}
data "google_client_config" "default" {
  provider = google
}
data "google_client_openid_userinfo" "me" {
}

provider "google" {
  project = var.shared_vpc_project_id
  region  = var.region
}
