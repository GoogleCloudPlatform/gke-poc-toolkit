{
  "version": 4,
  "terraform_version": "0.14.9",
  "serial": 39,
  "lineage": "5ac6a8cc-a131-aaa6-2edf-83bc04bc10f7",
  "outputs": {
    "bastion_kubectl_command": {
      "value": "kubectl get pods --all-namespaces",
      "type": "string"
    },
    "bastion_name": {
      "value": "",
      "type": "string"
    },
    "bastion_ssh_command": {
      "value": "",
      "type": "string"
    },
    "ca_certificate": {
      "value": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURLakNDQWhLZ0F3SUJBZ0lRQk1kWU1iRnNpT25mYmtMc2tJalQ1VEFOQmdrcWhraUc5dzBCQVFzRkFEQXYKTVMwd0t3WURWUVFERXlRM1kyTmxNMkl4Tmkwek5ESTFMVFJsTjJNdFlUVTRZaTB4Wm1ZMU1tWmlOalEyTXpBdwpIaGNOTWpFd05ESXlNVE13T1RReFdoY05Nall3TkRJeE1UUXdPVFF4V2pBdk1TMHdLd1lEVlFRREV5UTNZMk5sCk0ySXhOaTB6TkRJMUxUUmxOMk10WVRVNFlpMHhabVkxTW1aaU5qUTJNekF3Z2dFaU1BMEdDU3FHU0liM0RRRUIKQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUUNzODhjRGpIQTN3bHpwRE5rMVJTZG4xOEdPZW1HZGNZbU9aa2s0M0dsdwpwSXBweGlxMnY3SFkyT2VoM3o3WHhDdzY3NzhRU0dOQ2JsUGpCWUp4OHphNW45Q0QvaEdhWWdFUi9DdUE4U085CkRPUmJKU1lUMmgrUFpLWjZWUjU5cTF1d1hDQmVPTUJjL3BaMjhHWmI1SVdyVFdzT1NrZE5DUGxBczNScW4xblQKZUs3dGtabmREV3pmRlpIZ2VPYVEybjVKTTBVR3kvOG1CeE9hMElQVExmcmlWS0s1ay9pdHhWV2VQVklGNUx4eApCbGEvTnJDSkpzNVZmYWNIUmx5RlJBZ3FEbGxEUmczb2IxN3E1YlJwaFYyNGdhaGZPa3J1S3lndFBZNjBCWGZzCmZ6NVZjK3Q4ajBFcjNLVlJuZlJ0WWZ2enNIWGdFc2FOaWZ5NERWKzBBYXlUQWdNQkFBR2pRakJBTUE0R0ExVWQKRHdFQi93UUVBd0lDQkRBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSQmN2N0VEbFdaM3NkSgpwUldPM2x0Wk9Pb0xOVEFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBWCt4Ri84NEo1Rnl0Y2l1RVRIeSs5NDhTClNybDl3dHluUEhHaHpTaytGbmMwNTROM0VaUGMvTEZzQ0FiN0tuYnJEaW5xYjF4TWJwOTI1Y2xDTTNrZzJyMjQKVy8rZDR3YmdhYldVTWk0ZkRQbUZXTG9FLzRjaEVaTm1KOCsySG9pQnp2c00zOW0vd1dJcDNtbzNSOWhFbEtiVQpnTDJYU0ROZ01hU2pGUlk1ZThwdm44cGYxU2M0K2ZhYVhWd1hlekhiMTl6MkhYUmZWdHpnU1NSSzVOa3A1d0dzCmtFQ0x2SUo4UzRHSVZzbTcxZnlpWjlHZDQwbU1vTXZsellpejZwS2s0VEJRQ0FsOHJ3VHZWKzJJa2YrSnQ2dkEKUnUwRTNWRGlXQWtlbitTTHVCUEovS0pGY3Y0VGcxcVd0UU15NzJTbTRZUGNLMFQyWHB2MlJsZWlBN2JweUE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",
      "type": "string",
      "sensitive": true
    },
    "cluster_name": {
      "value": "public-endpoint-cluster",
      "type": "string"
    },
    "endpoint": {
      "value": "172.16.0.18",
      "type": "string",
      "sensitive": true
    },
    "get_credentials_command": {
      "value": "gcloud container clusters get-credentials --project alw-gke-106 --zone northamerica-northeast1 public-endpoint-cluster",
      "type": "string"
    }
  },
  "resources": [
    {
      "mode": "data",
      "type": "google_client_config",
      "name": "default",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "access_token": "ya29.a0AfH6SMDGqVxOMtFSqC0mNgC7Y2JrymQuRO3VMC9i9zAKYBOUrUMRRESJvcev3hu2jk7lg9_hhRPc0zuHoLZzuv8vIX-YdEG2vDgzoRnzztRFJxTXuvu2CZA7fG4TY8Wb6T5ipy9hYA7ku5bBiJr-4bPlyKzcsJCPdcDike5i-XXoOlh_gjgjIy_-R-eSEGcZz1Neej4wfONb-mj1fJ_0if6XDb8mMUD5mmiZqqYr0mkNnQSPj8uYJ_CY8B432LwhJikPvTQ",
            "id": "projects/alw-gke-106/regions//zones/",
            "project": "alw-gke-106",
            "region": "",
            "zone": ""
          },
          "sensitive_attributes": []
        }
      ]
    },
    {
      "mode": "data",
      "type": "google_client_openid_userinfo",
      "name": "me",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "email": "admin@wolchesky.altostrat.com",
            "id": "admin@wolchesky.altostrat.com"
          },
          "sensitive_attributes": []
        }
      ]
    },
    {
      "mode": "data",
      "type": "google_project",
      "name": "project",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "auto_create_network": null,
            "billing_account": "01EA0A-CF27AA-7838F7",
            "folder_id": "",
            "id": "projects/alw-gke-106",
            "labels": {},
            "name": "alw-gke-106",
            "number": "700448436738",
            "org_id": "920109858128",
            "project_id": "alw-gke-106",
            "skip_delete": null
          },
          "sensitive_attributes": []
        }
      ]
    },
    {
      "mode": "data",
      "type": "template_file",
      "name": "startup_script",
      "provider": "provider[\"registry.terraform.io/hashicorp/template\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "filename": null,
            "id": "5342018eb1c9e1064c7484cc318ec9b657db7cf30d11973012b6b4bbdb6acad7",
            "rendered": "sudo apt-get update -y\nsudo apt-get install -y tinyproxy\n",
            "template": "sudo apt-get update -y\nsudo apt-get install -y tinyproxy\n",
            "vars": null
          },
          "sensitive_attributes": []
        }
      ]
    },
    {
      "mode": "managed",
      "type": "random_id",
      "name": "kms",
      "provider": "provider[\"registry.terraform.io/hashicorp/random\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "b64_std": "32Y=",
            "b64_url": "32Y",
            "byte_length": 2,
            "dec": "57190",
            "hex": "df66",
            "id": "32Y",
            "keepers": null,
            "prefix": null
          },
          "sensitive_attributes": [],
          "private": "bnVsbA=="
        }
      ]
    },
    {
      "module": "module.cluster-nat",
      "mode": "managed",
      "type": "google_compute_router",
      "name": "router",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "index_key": 0,
          "schema_version": 0,
          "attributes": {
            "bgp": [
              {
                "advertise_mode": "DEFAULT",
                "advertised_groups": null,
                "advertised_ip_ranges": [],
                "asn": 64514
              }
            ],
            "creation_timestamp": "2021-04-22T07:09:20.346-07:00",
            "description": "",
            "id": "projects/alw-gke-106/regions/northamerica-northeast1/routers/private-cluster-router",
            "name": "private-cluster-router",
            "network": "https://www.googleapis.com/compute/v1/projects/alw-gke-106/global/networks/public-cluster-network",
            "project": "alw-gke-106",
            "region": "northamerica-northeast1",
            "self_link": "https://www.googleapis.com/compute/v1/projects/alw-gke-106/regions/northamerica-northeast1/routers/private-cluster-router",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoyNDAwMDAwMDAwMDAsImRlbGV0ZSI6MjQwMDAwMDAwMDAwLCJ1cGRhdGUiOjI0MDAwMDAwMDAwMH19",
          "dependencies": [
            "module.enabled_google_apis.google_project_service.project_services",
            "module.vpc.module.vpc.google_compute_network.network"
          ]
        }
      ]
    },
    {
      "module": "module.cluster-nat",
      "mode": "managed",
      "type": "google_compute_router_nat",
      "name": "main",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "drain_nat_ips": null,
            "enable_endpoint_independent_mapping": true,
            "icmp_idle_timeout_sec": 30,
            "id": "alw-gke-106/northamerica-northeast1/private-cluster-router/cloud-nat-ramnm4",
            "log_config": [],
            "min_ports_per_vm": 64,
            "name": "cloud-nat-ramnm4",
            "nat_ip_allocate_option": "AUTO_ONLY",
            "nat_ips": null,
            "project": "alw-gke-106",
            "region": "northamerica-northeast1",
            "router": "private-cluster-router",
            "source_subnetwork_ip_ranges_to_nat": "ALL_SUBNETWORKS_ALL_IP_RANGES",
            "subnetwork": [],
            "tcp_established_idle_timeout_sec": 1200,
            "tcp_transitory_idle_timeout_sec": 30,
            "timeouts": null,
            "udp_idle_timeout_sec": 30
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjo2MDAwMDAwMDAwMDAsImRlbGV0ZSI6NjAwMDAwMDAwMDAwLCJ1cGRhdGUiOjYwMDAwMDAwMDAwMH19",
          "dependencies": [
            "module.cluster-nat.google_compute_router.router",
            "module.cluster-nat.random_string.name_suffix",
            "module.enabled_google_apis.google_project_service.project_services",
            "module.vpc.module.vpc.google_compute_network.network"
          ]
        }
      ]
    },
    {
      "module": "module.cluster-nat",
      "mode": "managed",
      "type": "random_string",
      "name": "name_suffix",
      "provider": "provider[\"registry.terraform.io/hashicorp/random\"]",
      "instances": [
        {
          "schema_version": 1,
          "attributes": {
            "id": "ramnm4",
            "keepers": null,
            "length": 6,
            "lower": true,
            "min_lower": 0,
            "min_numeric": 0,
            "min_special": 0,
            "min_upper": 0,
            "number": true,
            "override_special": null,
            "result": "ramnm4",
            "special": false,
            "upper": false
          },
          "sensitive_attributes": [],
          "private": "eyJzY2hlbWFfdmVyc2lvbiI6IjEifQ=="
        }
      ]
    },
    {
      "module": "module.enabled_google_apis",
      "mode": "managed",
      "type": "google_project_service",
      "name": "project_services",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "index_key": "binaryauthorization.googleapis.com",
          "schema_version": 0,
          "attributes": {
            "disable_dependent_services": true,
            "disable_on_destroy": false,
            "id": "alw-gke-106/binaryauthorization.googleapis.com",
            "project": "alw-gke-106",
            "service": "binaryauthorization.googleapis.com",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInJlYWQiOjYwMDAwMDAwMDAwMCwidXBkYXRlIjoxMjAwMDAwMDAwMDAwfX0="
        },
        {
          "index_key": "compute.googleapis.com",
          "schema_version": 0,
          "attributes": {
            "disable_dependent_services": true,
            "disable_on_destroy": false,
            "id": "alw-gke-106/compute.googleapis.com",
            "project": "alw-gke-106",
            "service": "compute.googleapis.com",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInJlYWQiOjYwMDAwMDAwMDAwMCwidXBkYXRlIjoxMjAwMDAwMDAwMDAwfX0="
        },
        {
          "index_key": "container.googleapis.com",
          "schema_version": 0,
          "attributes": {
            "disable_dependent_services": true,
            "disable_on_destroy": false,
            "id": "alw-gke-106/container.googleapis.com",
            "project": "alw-gke-106",
            "service": "container.googleapis.com",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInJlYWQiOjYwMDAwMDAwMDAwMCwidXBkYXRlIjoxMjAwMDAwMDAwMDAwfX0="
        },
        {
          "index_key": "containerregistry.googleapis.com",
          "schema_version": 0,
          "attributes": {
            "disable_dependent_services": true,
            "disable_on_destroy": false,
            "id": "alw-gke-106/containerregistry.googleapis.com",
            "project": "alw-gke-106",
            "service": "containerregistry.googleapis.com",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInJlYWQiOjYwMDAwMDAwMDAwMCwidXBkYXRlIjoxMjAwMDAwMDAwMDAwfX0="
        },
        {
          "index_key": "iam.googleapis.com",
          "schema_version": 0,
          "attributes": {
            "disable_dependent_services": true,
            "disable_on_destroy": false,
            "id": "alw-gke-106/iam.googleapis.com",
            "project": "alw-gke-106",
            "service": "iam.googleapis.com",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInJlYWQiOjYwMDAwMDAwMDAwMCwidXBkYXRlIjoxMjAwMDAwMDAwMDAwfX0="
        },
        {
          "index_key": "iap.googleapis.com",
          "schema_version": 0,
          "attributes": {
            "disable_dependent_services": true,
            "disable_on_destroy": false,
            "id": "alw-gke-106/iap.googleapis.com",
            "project": "alw-gke-106",
            "service": "iap.googleapis.com",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInJlYWQiOjYwMDAwMDAwMDAwMCwidXBkYXRlIjoxMjAwMDAwMDAwMDAwfX0="
        },
        {
          "index_key": "logging.googleapis.com",
          "schema_version": 0,
          "attributes": {
            "disable_dependent_services": true,
            "disable_on_destroy": false,
            "id": "alw-gke-106/logging.googleapis.com",
            "project": "alw-gke-106",
            "service": "logging.googleapis.com",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInJlYWQiOjYwMDAwMDAwMDAwMCwidXBkYXRlIjoxMjAwMDAwMDAwMDAwfX0="
        },
        {
          "index_key": "monitoring.googleapis.com",
          "schema_version": 0,
          "attributes": {
            "disable_dependent_services": true,
            "disable_on_destroy": false,
            "id": "alw-gke-106/monitoring.googleapis.com",
            "project": "alw-gke-106",
            "service": "monitoring.googleapis.com",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInJlYWQiOjYwMDAwMDAwMDAwMCwidXBkYXRlIjoxMjAwMDAwMDAwMDAwfX0="
        },
        {
          "index_key": "stackdriver.googleapis.com",
          "schema_version": 0,
          "attributes": {
            "disable_dependent_services": true,
            "disable_on_destroy": false,
            "id": "alw-gke-106/stackdriver.googleapis.com",
            "project": "alw-gke-106",
            "service": "stackdriver.googleapis.com",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInJlYWQiOjYwMDAwMDAwMDAwMCwidXBkYXRlIjoxMjAwMDAwMDAwMDAwfX0="
        }
      ]
    },
    {
      "module": "module.enabled_governance_apis",
      "mode": "managed",
      "type": "google_project_service",
      "name": "project_services",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "index_key": "cloudkms.googleapis.com",
          "schema_version": 0,
          "attributes": {
            "disable_dependent_services": true,
            "disable_on_destroy": false,
            "id": "alw-gke-106/cloudkms.googleapis.com",
            "project": "alw-gke-106",
            "service": "cloudkms.googleapis.com",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInJlYWQiOjYwMDAwMDAwMDAwMCwidXBkYXRlIjoxMjAwMDAwMDAwMDAwfX0="
        }
      ]
    },
    {
      "module": "module.gke.module.gke",
      "mode": "data",
      "type": "google_client_config",
      "name": "default",
      "provider": "provider[\"registry.terraform.io/hashicorp/google-beta\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "access_token": "ya29.a0AfH6SMDGqVxOMtFSqC0mNgC7Y2JrymQuRO3VMC9i9zAKYBOUrUMRRESJvcev3hu2jk7lg9_hhRPc0zuHoLZzuv8vIX-YdEG2vDgzoRnzztRFJxTXuvu2CZA7fG4TY8Wb6T5ipy9hYA7ku5bBiJr-4bPlyKzcsJCPdcDike5i-XXoOlh_gjgjIy_-R-eSEGcZz1Neej4wfONb-mj1fJ_0if6XDb8mMUD5mmiZqqYr0mkNnQSPj8uYJ_CY8B432LwhJikPvTQ",
            "id": "projects/alw-gke-106/regions//zones/",
            "project": "alw-gke-106",
            "region": "",
            "zone": ""
          },
          "sensitive_attributes": []
        }
      ]
    },
    {
      "module": "module.gke.module.gke",
      "mode": "data",
      "type": "google_compute_zones",
      "name": "available",
      "provider": "provider[\"registry.terraform.io/hashicorp/google-beta\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "projects/alw-gke-106/regions/northamerica-northeast1",
            "names": [
              "northamerica-northeast1-a",
              "northamerica-northeast1-b",
              "northamerica-northeast1-c"
            ],
            "project": "alw-gke-106",
            "region": "northamerica-northeast1",
            "status": null
          },
          "sensitive_attributes": []
        }
      ]
    },
    {
      "module": "module.gke.module.gke",
      "mode": "data",
      "type": "google_container_engine_versions",
      "name": "region",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "default_cluster_version": "1.17.17-gke.3000",
            "id": "2021-04-22 14:09:13.049045014 +0000 UTC",
            "latest_master_version": "1.19.8-gke.1600",
            "latest_node_version": "1.19.8-gke.1600",
            "location": "northamerica-northeast1",
            "project": "alw-gke-106",
            "release_channel_default_version": {
              "RAPID": "1.19.9-gke.100",
              "REGULAR": "1.18.16-gke.502",
              "STABLE": "1.17.17-gke.3000"
            },
            "valid_master_versions": [
              "1.19.8-gke.1600",
              "1.18.17-gke.700",
              "1.18.17-gke.100",
              "1.18.16-gke.2100",
              "1.18.16-gke.1201",
              "1.18.16-gke.502",
              "1.18.16-gke.302",
              "1.18.16-gke.300",
              "1.18.15-gke.1502",
              "1.18.15-gke.1501",
              "1.17.17-gke.5400",
              "1.17.17-gke.4900",
              "1.17.17-gke.4400",
              "1.17.17-gke.3700",
              "1.17.17-gke.3000",
              "1.17.17-gke.2800",
              "1.17.17-gke.1500",
              "1.17.17-gke.1101",
              "1.16.15-gke.14800",
              "1.16.15-gke.12500"
            ],
            "valid_node_versions": [
              "1.19.8-gke.1600",
              "1.18.17-gke.700",
              "1.18.17-gke.100",
              "1.18.16-gke.2100",
              "1.18.16-gke.1201",
              "1.18.16-gke.1200",
              "1.18.16-gke.502",
              "1.18.16-gke.500",
              "1.18.16-gke.302",
              "1.18.16-gke.300",
              "1.18.15-gke.2500",
              "1.18.15-gke.1502",
              "1.18.15-gke.1501",
              "1.18.15-gke.1500",
              "1.18.15-gke.1102",
              "1.18.15-gke.1100",
              "1.18.15-gke.800",
              "1.18.14-gke.1600",
              "1.18.14-gke.1200",
              "1.18.12-gke.1210",
              "1.18.12-gke.1206",
              "1.18.12-gke.1205",
              "1.18.12-gke.1201",
              "1.18.12-gke.1200",
              "1.18.12-gke.300",
              "1.18.10-gke.2701",
              "1.18.10-gke.2101",
              "1.18.10-gke.1500",
              "1.18.10-gke.601",
              "1.18.9-gke.2501",
              "1.18.9-gke.1501",
              "1.18.9-gke.801",
              "1.18.6-gke.4801",
              "1.18.6-gke.3504",
              "1.18.6-gke.3503",
              "1.17.17-gke.5400",
              "1.17.17-gke.4900",
              "1.17.17-gke.4400",
              "1.17.17-gke.3700",
              "1.17.17-gke.3000",
              "1.17.17-gke.2800",
              "1.17.17-gke.2500",
              "1.17.17-gke.1500",
              "1.17.17-gke.1101",
              "1.17.17-gke.1100",
              "1.17.17-gke.600",
              "1.17.16-gke.1600",
              "1.17.16-gke.1300",
              "1.17.15-gke.800",
              "1.17.15-gke.300",
              "1.17.14-gke.1600",
              "1.17.14-gke.1200",
              "1.17.14-gke.400",
              "1.17.13-gke.2600",
              "1.17.13-gke.2001",
              "1.17.13-gke.1401",
              "1.17.13-gke.1400",
              "1.17.13-gke.600",
              "1.17.12-gke.2502",
              "1.17.12-gke.1504",
              "1.17.12-gke.1501",
              "1.17.12-gke.500",
              "1.17.9-gke.6300",
              "1.17.9-gke.1504",
              "1.16.15-gke.14800",
              "1.16.15-gke.12500",
              "1.16.15-gke.11800",
              "1.16.15-gke.10600",
              "1.16.15-gke.7801",
              "1.16.15-gke.7800",
              "1.16.15-gke.7300",
              "1.16.15-gke.6900",
              "1.16.15-gke.6000",
              "1.16.15-gke.5500",
              "1.16.15-gke.4901",
              "1.16.15-gke.4301",
              "1.16.15-gke.4300",
              "1.16.15-gke.3500",
              "1.16.15-gke.2601",
              "1.16.15-gke.1600",
              "1.16.15-gke.500",
              "1.16.13-gke.404",
              "1.16.13-gke.403",
              "1.16.13-gke.401",
              "1.16.13-gke.400",
              "1.16.13-gke.1",
              "1.16.11-gke.5",
              "1.16.10-gke.8",
              "1.16.9-gke.6",
              "1.16.9-gke.2",
              "1.16.8-gke.15",
              "1.16.8-gke.12",
              "1.16.8-gke.9",
              "1.15.12-gke.6002",
              "1.15.12-gke.6001",
              "1.15.12-gke.5000",
              "1.15.12-gke.4002",
              "1.15.12-gke.4000",
              "1.15.12-gke.20",
              "1.15.12-gke.17",
              "1.15.12-gke.16",
              "1.15.12-gke.13",
              "1.15.12-gke.9",
              "1.15.12-gke.6",
              "1.15.12-gke.3",
              "1.15.12-gke.2",
              "1.15.11-gke.17",
              "1.15.11-gke.15",
              "1.15.11-gke.13",
              "1.15.11-gke.12",
              "1.15.11-gke.11",
              "1.15.11-gke.9",
              "1.15.11-gke.5",
              "1.15.11-gke.3",
              "1.15.11-gke.1",
              "1.15.9-gke.26",
              "1.15.9-gke.24",
              "1.15.9-gke.22",
              "1.15.9-gke.12",
              "1.15.9-gke.9",
              "1.15.9-gke.8",
              "1.15.8-gke.3",
              "1.15.8-gke.2",
              "1.15.7-gke.23",
              "1.15.7-gke.2",
              "1.15.4-gke.22",
              "1.14.10-gke.1504",
              "1.14.10-gke.902",
              "1.14.10-gke.50",
              "1.14.10-gke.46",
              "1.14.10-gke.45",
              "1.14.10-gke.42",
              "1.14.10-gke.41",
              "1.14.10-gke.40",
              "1.14.10-gke.37",
              "1.14.10-gke.36",
              "1.14.10-gke.34",
              "1.14.10-gke.32",
              "1.14.10-gke.31",
              "1.14.10-gke.27",
              "1.14.10-gke.24",
              "1.14.10-gke.22",
              "1.14.10-gke.21",
              "1.14.10-gke.17",
              "1.14.10-gke.0",
              "1.14.9-gke.23",
              "1.14.9-gke.2",
              "1.14.9-gke.0",
              "1.14.8-gke.33",
              "1.14.8-gke.21",
              "1.14.8-gke.18",
              "1.14.8-gke.17",
              "1.14.8-gke.14",
              "1.14.8-gke.12",
              "1.14.8-gke.7",
              "1.14.8-gke.2",
              "1.14.7-gke.40",
              "1.14.7-gke.25",
              "1.14.7-gke.23",
              "1.14.7-gke.17",
              "1.14.7-gke.14",
              "1.14.7-gke.10",
              "1.14.6-gke.13",
              "1.14.6-gke.2",
              "1.14.6-gke.1",
              "1.14.3-gke.11",
              "1.14.3-gke.10",
              "1.14.3-gke.9",
              "1.14.2-gke.9",
              "1.14.1-gke.5",
              "1.13.12-gke.30",
              "1.13.12-gke.25",
              "1.13.12-gke.17",
              "1.13.12-gke.16",
              "1.13.12-gke.14",
              "1.13.12-gke.13",
              "1.13.12-gke.10",
              "1.13.12-gke.8",
              "1.13.12-gke.4",
              "1.13.12-gke.2",
              "1.13.11-gke.23",
              "1.13.11-gke.15",
              "1.13.11-gke.14",
              "1.13.11-gke.12",
              "1.13.11-gke.11",
              "1.13.11-gke.9",
              "1.13.11-gke.5",
              "1.13.10-gke.7",
              "1.13.10-gke.0",
              "1.13.9-gke.11",
              "1.13.9-gke.3",
              "1.13.7-gke.24",
              "1.13.7-gke.19",
              "1.13.7-gke.15",
              "1.13.7-gke.8",
              "1.13.7-gke.0",
              "1.13.6-gke.13",
              "1.13.6-gke.6",
              "1.13.6-gke.5",
              "1.13.6-gke.0",
              "1.13.5-gke.10",
              "1.12.10-gke.22",
              "1.12.10-gke.20",
              "1.12.10-gke.19",
              "1.12.10-gke.18",
              "1.12.10-gke.17",
              "1.12.10-gke.15",
              "1.12.10-gke.13",
              "1.12.10-gke.11",
              "1.12.10-gke.5",
              "1.12.9-gke.16",
              "1.12.9-gke.15",
              "1.12.9-gke.13",
              "1.12.9-gke.10",
              "1.12.9-gke.7",
              "1.12.9-gke.3",
              "1.12.8-gke.12",
              "1.12.8-gke.10",
              "1.12.8-gke.7",
              "1.12.8-gke.6",
              "1.12.7-gke.26",
              "1.12.7-gke.25",
              "1.12.7-gke.24",
              "1.12.7-gke.22",
              "1.12.7-gke.21",
              "1.12.7-gke.17",
              "1.12.7-gke.10",
              "1.12.7-gke.7",
              "1.12.6-gke.11",
              "1.12.6-gke.10",
              "1.12.6-gke.7",
              "1.12.5-gke.10",
              "1.12.5-gke.5",
              "1.11.10-gke.6",
              "1.11.10-gke.5"
            ],
            "version_prefix": null
          },
          "sensitive_attributes": []
        }
      ]
    },
    {
      "module": "module.gke.module.gke",
      "mode": "data",
      "type": "google_container_engine_versions",
      "name": "zone",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "default_cluster_version": "1.17.17-gke.3000",
            "id": "2021-04-22 14:09:13.338506159 +0000 UTC",
            "latest_master_version": "1.19.8-gke.1600",
            "latest_node_version": "1.19.8-gke.1600",
            "location": "northamerica-northeast1-a",
            "project": "alw-gke-106",
            "release_channel_default_version": {
              "RAPID": "1.19.9-gke.100",
              "REGULAR": "1.18.16-gke.502",
              "STABLE": "1.17.17-gke.3000"
            },
            "valid_master_versions": [
              "1.19.8-gke.1600",
              "1.18.17-gke.700",
              "1.18.17-gke.100",
              "1.18.16-gke.2100",
              "1.18.16-gke.1201",
              "1.18.16-gke.502",
              "1.18.16-gke.302",
              "1.18.16-gke.300",
              "1.18.15-gke.1502",
              "1.18.15-gke.1501",
              "1.17.17-gke.5400",
              "1.17.17-gke.4900",
              "1.17.17-gke.4400",
              "1.17.17-gke.3700",
              "1.17.17-gke.3000",
              "1.17.17-gke.2800",
              "1.17.17-gke.1500",
              "1.17.17-gke.1101",
              "1.16.15-gke.14800",
              "1.16.15-gke.12500"
            ],
            "valid_node_versions": [
              "1.19.8-gke.1600",
              "1.18.17-gke.700",
              "1.18.17-gke.100",
              "1.18.16-gke.2100",
              "1.18.16-gke.1201",
              "1.18.16-gke.1200",
              "1.18.16-gke.502",
              "1.18.16-gke.500",
              "1.18.16-gke.302",
              "1.18.16-gke.300",
              "1.18.15-gke.2500",
              "1.18.15-gke.1502",
              "1.18.15-gke.1501",
              "1.18.15-gke.1500",
              "1.18.15-gke.1102",
              "1.18.15-gke.1100",
              "1.18.15-gke.800",
              "1.18.14-gke.1600",
              "1.18.14-gke.1200",
              "1.18.12-gke.1210",
              "1.18.12-gke.1206",
              "1.18.12-gke.1205",
              "1.18.12-gke.1201",
              "1.18.12-gke.1200",
              "1.18.12-gke.300",
              "1.18.10-gke.2701",
              "1.18.10-gke.2101",
              "1.18.10-gke.1500",
              "1.18.10-gke.601",
              "1.18.9-gke.2501",
              "1.18.9-gke.1501",
              "1.18.9-gke.801",
              "1.18.6-gke.4801",
              "1.18.6-gke.3504",
              "1.18.6-gke.3503",
              "1.17.17-gke.5400",
              "1.17.17-gke.4900",
              "1.17.17-gke.4400",
              "1.17.17-gke.3700",
              "1.17.17-gke.3000",
              "1.17.17-gke.2800",
              "1.17.17-gke.2500",
              "1.17.17-gke.1500",
              "1.17.17-gke.1101",
              "1.17.17-gke.1100",
              "1.17.17-gke.600",
              "1.17.16-gke.1600",
              "1.17.16-gke.1300",
              "1.17.15-gke.800",
              "1.17.15-gke.300",
              "1.17.14-gke.1600",
              "1.17.14-gke.1200",
              "1.17.14-gke.400",
              "1.17.13-gke.2600",
              "1.17.13-gke.2001",
              "1.17.13-gke.1401",
              "1.17.13-gke.1400",
              "1.17.13-gke.600",
              "1.17.12-gke.2502",
              "1.17.12-gke.1504",
              "1.17.12-gke.1501",
              "1.17.12-gke.500",
              "1.17.9-gke.6300",
              "1.17.9-gke.1504",
              "1.16.15-gke.14800",
              "1.16.15-gke.12500",
              "1.16.15-gke.11800",
              "1.16.15-gke.10600",
              "1.16.15-gke.7801",
              "1.16.15-gke.7800",
              "1.16.15-gke.7300",
              "1.16.15-gke.6900",
              "1.16.15-gke.6000",
              "1.16.15-gke.5500",
              "1.16.15-gke.4901",
              "1.16.15-gke.4301",
              "1.16.15-gke.4300",
              "1.16.15-gke.3500",
              "1.16.15-gke.2601",
              "1.16.15-gke.1600",
              "1.16.15-gke.500",
              "1.16.13-gke.404",
              "1.16.13-gke.403",
              "1.16.13-gke.401",
              "1.16.13-gke.400",
              "1.16.13-gke.1",
              "1.16.11-gke.5",
              "1.16.10-gke.8",
              "1.16.9-gke.6",
              "1.16.9-gke.2",
              "1.16.8-gke.15",
              "1.16.8-gke.12",
              "1.16.8-gke.9",
              "1.15.12-gke.6002",
              "1.15.12-gke.6001",
              "1.15.12-gke.5000",
              "1.15.12-gke.4002",
              "1.15.12-gke.4000",
              "1.15.12-gke.20",
              "1.15.12-gke.17",
              "1.15.12-gke.16",
              "1.15.12-gke.13",
              "1.15.12-gke.9",
              "1.15.12-gke.6",
              "1.15.12-gke.3",
              "1.15.12-gke.2",
              "1.15.11-gke.17",
              "1.15.11-gke.15",
              "1.15.11-gke.13",
              "1.15.11-gke.12",
              "1.15.11-gke.11",
              "1.15.11-gke.9",
              "1.15.11-gke.5",
              "1.15.11-gke.3",
              "1.15.11-gke.1",
              "1.15.9-gke.26",
              "1.15.9-gke.24",
              "1.15.9-gke.22",
              "1.15.9-gke.12",
              "1.15.9-gke.9",
              "1.15.9-gke.8",
              "1.15.8-gke.3",
              "1.15.8-gke.2",
              "1.15.7-gke.23",
              "1.15.7-gke.2",
              "1.15.4-gke.22",
              "1.14.10-gke.1504",
              "1.14.10-gke.902",
              "1.14.10-gke.50",
              "1.14.10-gke.46",
              "1.14.10-gke.45",
              "1.14.10-gke.42",
              "1.14.10-gke.41",
              "1.14.10-gke.40",
              "1.14.10-gke.37",
              "1.14.10-gke.36",
              "1.14.10-gke.34",
              "1.14.10-gke.32",
              "1.14.10-gke.31",
              "1.14.10-gke.27",
              "1.14.10-gke.24",
              "1.14.10-gke.22",
              "1.14.10-gke.21",
              "1.14.10-gke.17",
              "1.14.10-gke.0",
              "1.14.9-gke.23",
              "1.14.9-gke.2",
              "1.14.9-gke.0",
              "1.14.8-gke.33",
              "1.14.8-gke.21",
              "1.14.8-gke.18",
              "1.14.8-gke.17",
              "1.14.8-gke.14",
              "1.14.8-gke.12",
              "1.14.8-gke.7",
              "1.14.8-gke.2",
              "1.14.7-gke.40",
              "1.14.7-gke.25",
              "1.14.7-gke.23",
              "1.14.7-gke.17",
              "1.14.7-gke.14",
              "1.14.7-gke.10",
              "1.14.6-gke.13",
              "1.14.6-gke.2",
              "1.14.6-gke.1",
              "1.14.3-gke.11",
              "1.14.3-gke.10",
              "1.14.3-gke.9",
              "1.14.2-gke.9",
              "1.14.1-gke.5",
              "1.13.12-gke.30",
              "1.13.12-gke.25",
              "1.13.12-gke.17",
              "1.13.12-gke.16",
              "1.13.12-gke.14",
              "1.13.12-gke.13",
              "1.13.12-gke.10",
              "1.13.12-gke.8",
              "1.13.12-gke.4",
              "1.13.12-gke.2",
              "1.13.11-gke.23",
              "1.13.11-gke.15",
              "1.13.11-gke.14",
              "1.13.11-gke.12",
              "1.13.11-gke.11",
              "1.13.11-gke.9",
              "1.13.11-gke.5",
              "1.13.10-gke.7",
              "1.13.10-gke.0",
              "1.13.9-gke.11",
              "1.13.9-gke.3",
              "1.13.7-gke.24",
              "1.13.7-gke.19",
              "1.13.7-gke.15",
              "1.13.7-gke.8",
              "1.13.7-gke.0",
              "1.13.6-gke.13",
              "1.13.6-gke.6",
              "1.13.6-gke.5",
              "1.13.6-gke.0",
              "1.13.5-gke.10",
              "1.12.10-gke.22",
              "1.12.10-gke.20",
              "1.12.10-gke.19",
              "1.12.10-gke.18",
              "1.12.10-gke.17",
              "1.12.10-gke.15",
              "1.12.10-gke.13",
              "1.12.10-gke.11",
              "1.12.10-gke.5",
              "1.12.9-gke.16",
              "1.12.9-gke.15",
              "1.12.9-gke.13",
              "1.12.9-gke.10",
              "1.12.9-gke.7",
              "1.12.9-gke.3",
              "1.12.8-gke.12",
              "1.12.8-gke.10",
              "1.12.8-gke.7",
              "1.12.8-gke.6",
              "1.12.7-gke.26",
              "1.12.7-gke.25",
              "1.12.7-gke.24",
              "1.12.7-gke.22",
              "1.12.7-gke.21",
              "1.12.7-gke.17",
              "1.12.7-gke.10",
              "1.12.7-gke.7",
              "1.12.6-gke.11",
              "1.12.6-gke.10",
              "1.12.6-gke.7",
              "1.12.5-gke.10",
              "1.12.5-gke.5",
              "1.11.10-gke.6",
              "1.11.10-gke.5"
            ],
            "version_prefix": null
          },
          "sensitive_attributes": []
        }
      ]
    },
    {
      "module": "module.gke.module.gke",
      "mode": "managed",
      "type": "google_container_cluster",
      "name": "primary",
      "provider": "provider[\"registry.terraform.io/hashicorp/google-beta\"]",
      "instances": [
        {
          "schema_version": 1,
          "attributes": {
            "addons_config": [
              {
                "cloudrun_config": [],
                "config_connector_config": [
                  {
                    "enabled": false
                  }
                ],
                "dns_cache_config": [
                  {
                    "enabled": false
                  }
                ],
                "gce_persistent_disk_csi_driver_config": [
                  {
                    "enabled": true
                  }
                ],
                "horizontal_pod_autoscaling": [
                  {
                    "disabled": false
                  }
                ],
                "http_load_balancing": [
                  {
                    "disabled": false
                  }
                ],
                "istio_config": [
                  {
                    "auth": "AUTH_MUTUAL_TLS",
                    "disabled": true
                  }
                ],
                "kalm_config": [
                  {
                    "enabled": false
                  }
                ],
                "network_policy_config": [
                  {
                    "disabled": false
                  }
                ]
              }
            ],
            "authenticator_groups_config": [],
            "cluster_autoscaling": [
              {
                "auto_provisioning_defaults": [],
                "autoscaling_profile": "BALANCED",
                "enabled": false,
                "resource_limits": []
              }
            ],
            "cluster_ipv4_cidr": "10.10.64.0/18",
            "cluster_telemetry": [
              {
                "type": "ENABLED"
              }
            ],
            "confidential_nodes": [],
            "database_encryption": [
              {
                "key_name": "projects/alw-gke-106/locations/northamerica-northeast1/keyRings/public-endpoint-cluster-kr-df66/cryptoKeys/public-endpoint-cluster-kek",
                "state": "ENCRYPTED"
              }
            ],
            "datapath_provider": "",
            "default_max_pods_per_node": 110,
            "default_snat_status": [
              {
                "disabled": false
              }
            ],
            "description": "",
            "enable_binary_authorization": true,
            "enable_intranode_visibility": false,
            "enable_kubernetes_alpha": false,
            "enable_legacy_abac": false,
            "enable_shielded_nodes": true,
            "enable_tpu": false,
            "endpoint": "34.95.29.85",
            "id": "projects/alw-gke-106/locations/northamerica-northeast1/clusters/public-endpoint-cluster",
            "initial_node_count": 0,
            "instance_group_urls": [],
            "ip_allocation_policy": [
              {
                "cluster_ipv4_cidr_block": "10.10.64.0/18",
                "cluster_secondary_range_name": "ip-range-pods",
                "services_ipv4_cidr_block": "10.10.192.0/18",
                "services_secondary_range_name": "ip-range-svc"
              }
            ],
            "label_fingerprint": "a9dc16a7",
            "location": "northamerica-northeast1",
            "logging_service": "logging.googleapis.com/kubernetes",
            "maintenance_policy": [
              {
                "daily_maintenance_window": [
                  {
                    "duration": "PT4H0M0S",
                    "start_time": "05:00"
                  }
                ],
                "maintenance_exclusion": [],
                "recurring_window": []
              }
            ],
            "master_auth": [
              {
                "client_certificate": "",
                "client_certificate_config": [
                  {
                    "issue_client_certificate": false
                  }
                ],
                "client_key": "",
                "cluster_ca_certificate": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURLakNDQWhLZ0F3SUJBZ0lRQk1kWU1iRnNpT25mYmtMc2tJalQ1VEFOQmdrcWhraUc5dzBCQVFzRkFEQXYKTVMwd0t3WURWUVFERXlRM1kyTmxNMkl4Tmkwek5ESTFMVFJsTjJNdFlUVTRZaTB4Wm1ZMU1tWmlOalEyTXpBdwpIaGNOTWpFd05ESXlNVE13T1RReFdoY05Nall3TkRJeE1UUXdPVFF4V2pBdk1TMHdLd1lEVlFRREV5UTNZMk5sCk0ySXhOaTB6TkRJMUxUUmxOMk10WVRVNFlpMHhabVkxTW1aaU5qUTJNekF3Z2dFaU1BMEdDU3FHU0liM0RRRUIKQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUUNzODhjRGpIQTN3bHpwRE5rMVJTZG4xOEdPZW1HZGNZbU9aa2s0M0dsdwpwSXBweGlxMnY3SFkyT2VoM3o3WHhDdzY3NzhRU0dOQ2JsUGpCWUp4OHphNW45Q0QvaEdhWWdFUi9DdUE4U085CkRPUmJKU1lUMmgrUFpLWjZWUjU5cTF1d1hDQmVPTUJjL3BaMjhHWmI1SVdyVFdzT1NrZE5DUGxBczNScW4xblQKZUs3dGtabmREV3pmRlpIZ2VPYVEybjVKTTBVR3kvOG1CeE9hMElQVExmcmlWS0s1ay9pdHhWV2VQVklGNUx4eApCbGEvTnJDSkpzNVZmYWNIUmx5RlJBZ3FEbGxEUmczb2IxN3E1YlJwaFYyNGdhaGZPa3J1S3lndFBZNjBCWGZzCmZ6NVZjK3Q4ajBFcjNLVlJuZlJ0WWZ2enNIWGdFc2FOaWZ5NERWKzBBYXlUQWdNQkFBR2pRakJBTUE0R0ExVWQKRHdFQi93UUVBd0lDQkRBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSQmN2N0VEbFdaM3NkSgpwUldPM2x0Wk9Pb0xOVEFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBWCt4Ri84NEo1Rnl0Y2l1RVRIeSs5NDhTClNybDl3dHluUEhHaHpTaytGbmMwNTROM0VaUGMvTEZzQ0FiN0tuYnJEaW5xYjF4TWJwOTI1Y2xDTTNrZzJyMjQKVy8rZDR3YmdhYldVTWk0ZkRQbUZXTG9FLzRjaEVaTm1KOCsySG9pQnp2c00zOW0vd1dJcDNtbzNSOWhFbEtiVQpnTDJYU0ROZ01hU2pGUlk1ZThwdm44cGYxU2M0K2ZhYVhWd1hlekhiMTl6MkhYUmZWdHpnU1NSSzVOa3A1d0dzCmtFQ0x2SUo4UzRHSVZzbTcxZnlpWjlHZDQwbU1vTXZsellpejZwS2s0VEJRQ0FsOHJ3VHZWKzJJa2YrSnQ2dkEKUnUwRTNWRGlXQWtlbitTTHVCUEovS0pGY3Y0VGcxcVd0UU15NzJTbTRZUGNLMFQyWHB2MlJsZWlBN2JweUE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",
                "password": "",
                "username": ""
              }
            ],
            "master_authorized_networks_config": [
              {
                "cidr_blocks": [
                  {
                    "cidr_block": "35.231.111.81/32",
                    "display_name": "Bastion Host"
                  }
                ]
              }
            ],
            "master_version": "1.18.16-gke.502",
            "min_master_version": null,
            "monitoring_service": "monitoring.googleapis.com/kubernetes",
            "name": "public-endpoint-cluster",
            "network": "projects/alw-gke-106/global/networks/public-cluster-network",
            "network_policy": [
              {
                "enabled": true,
                "provider": "CALICO"
              }
            ],
            "networking_mode": "VPC_NATIVE",
            "node_config": [],
            "node_locations": [
              "northamerica-northeast1-a",
              "northamerica-northeast1-b",
              "northamerica-northeast1-c"
            ],
            "node_pool": [],
            "node_version": "1.18.16-gke.502",
            "notification_config": [
              {
                "pubsub": [
                  {
                    "enabled": false,
                    "topic": ""
                  }
                ]
              }
            ],
            "operation": null,
            "pod_security_policy_config": [
              {
                "enabled": false
              }
            ],
            "private_cluster_config": [
              {
                "enable_private_endpoint": false,
                "enable_private_nodes": true,
                "master_global_access_config": [
                  {
                    "enabled": true
                  }
                ],
                "master_ipv4_cidr_block": "172.16.0.16/28",
                "peering_name": "gke-n76b711a626ac87dcbb4-645e-ff05-peer",
                "private_endpoint": "172.16.0.18",
                "public_endpoint": "34.95.29.85"
              }
            ],
            "project": "alw-gke-106",
            "release_channel": [
              {
                "channel": "REGULAR"
              }
            ],
            "remove_default_node_pool": true,
            "resource_labels": null,
            "resource_usage_export_config": [],
            "self_link": "https://container.googleapis.com/v1beta1/projects/alw-gke-106/locations/northamerica-northeast1/clusters/public-endpoint-cluster",
            "services_ipv4_cidr": "10.10.192.0/18",
            "subnetwork": "projects/alw-gke-106/regions/northamerica-northeast1/subnetworks/public-cluster-subnet",
            "timeouts": {
              "create": "45m",
              "delete": "45m",
              "read": null,
              "update": "45m"
            },
            "tpu_ipv4_cidr_block": "",
            "vertical_pod_autoscaling": [
              {
                "enabled": false
              }
            ],
            "workload_identity_config": [
              {
                "identity_namespace": "alw-gke-106.svc.id.goog"
              }
            ]
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoyNzAwMDAwMDAwMDAwLCJkZWxldGUiOjI3MDAwMDAwMDAwMDAsInJlYWQiOjI0MDAwMDAwMDAwMDAsInVwZGF0ZSI6MjcwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiMSJ9",
          "dependencies": [
            "data.google_client_openid_userinfo.me",
            "data.google_project.project",
            "data.template_file.startup_script",
            "module.bastion.google_compute_instance_from_template.bastion_vm",
            "module.bastion.google_project_iam_custom_role.compute_os_login_viewer",
            "module.bastion.google_project_iam_member.bastion_oslogin_bindings",
            "module.bastion.google_project_iam_member.bastion_sa_bindings",
            "module.bastion.google_service_account.bastion_host",
            "module.bastion.google_service_account_iam_binding.bastion_sa_user",
            "module.bastion.module.iap_tunneling.google_compute_firewall.allow_from_iap_to_instances",
            "module.bastion.module.iap_tunneling.google_iap_tunnel_instance_iam_binding.enable_iap",
            "module.bastion.module.instance_template.data.google_compute_image.image",
            "module.bastion.module.instance_template.data.google_compute_image.image_family",
            "module.bastion.module.instance_template.google_compute_instance_template.tpl",
            "module.bastion.random_id.random_role_id_suffix",
            "module.enabled_google_apis.google_project_service.project_services",
            "module.gke.module.gke.data.google_compute_zones.available",
            "module.gke.module.gke.data.google_container_engine_versions.region",
            "module.gke.module.gke.data.google_container_engine_versions.zone",
            "module.gke.module.gke.google_service_account.cluster_service_account",
            "module.gke.module.gke.random_shuffle.available_zones",
            "module.kms.google_kms_crypto_key.key",
            "module.kms.google_kms_crypto_key.key_ephemeral",
            "module.kms.google_kms_crypto_key_iam_binding.decrypters",
            "module.kms.google_kms_crypto_key_iam_binding.encrypters",
            "module.kms.google_kms_crypto_key_iam_binding.owners",
            "module.kms.google_kms_key_ring.key_ring",
            "module.service_accounts.data.template_file.keys",
            "module.service_accounts.google_billing_account_iam_member.billing_user",
            "module.service_accounts.google_organization_iam_member.billing_user",
            "module.service_accounts.google_organization_iam_member.organization_viewer",
            "module.service_accounts.google_organization_iam_member.xpn_admin",
            "module.service_accounts.google_project_iam_member.project-roles",
            "module.service_accounts.google_service_account.service_accounts",
            "module.service_accounts.google_service_account_key.keys",
            "module.vpc.module.subnets.google_compute_subnetwork.subnetwork",
            "module.vpc.module.vpc.google_compute_network.network",
            "random_id.kms"
          ]
        }
      ]
    },
    {
      "module": "module.gke.module.gke",
      "mode": "managed",
      "type": "google_container_node_pool",
      "name": "pools",
      "provider": "provider[\"registry.terraform.io/hashicorp/google-beta\"]",
      "instances": [
        {
          "index_key": "public-node-pool",
          "schema_version": 1,
          "attributes": {
            "autoscaling": [
              {
                "max_node_count": 3,
                "min_node_count": 3
              }
            ],
            "cluster": "public-endpoint-cluster",
            "id": "projects/alw-gke-106/locations/northamerica-northeast1/clusters/public-endpoint-cluster/nodePools/public-node-pool",
            "initial_node_count": 3,
            "instance_group_urls": [
              "https://www.googleapis.com/compute/v1/projects/alw-gke-106/zones/northamerica-northeast1-a/instanceGroupManagers/gke-public-endpoint--public-node-pool-2f76222c-grp",
              "https://www.googleapis.com/compute/v1/projects/alw-gke-106/zones/northamerica-northeast1-b/instanceGroupManagers/gke-public-endpoint--public-node-pool-decef519-grp",
              "https://www.googleapis.com/compute/v1/projects/alw-gke-106/zones/northamerica-northeast1-c/instanceGroupManagers/gke-public-endpoint--public-node-pool-d1e3ab15-grp"
            ],
            "location": "northamerica-northeast1",
            "management": [
              {
                "auto_repair": true,
                "auto_upgrade": true
              }
            ],
            "max_pods_per_node": 110,
            "name": "public-node-pool",
            "name_prefix": "",
            "node_config": [
              {
                "boot_disk_kms_key": "",
                "disk_size_gb": 30,
                "disk_type": "pd-ssd",
                "guest_accelerator": [],
                "image_type": "COS",
                "kubelet_config": [],
                "labels": {
                  "cluster_name": "public-endpoint-cluster",
                  "node_pool": "public-node-pool"
                },
                "linux_node_config": [],
                "local_ssd_count": 0,
                "machine_type": "n1-standard-2",
                "metadata": {
                  "cluster_name": "public-endpoint-cluster",
                  "disable-legacy-endpoints": "true",
                  "google-compute-enable-virtio-rng": "true",
                  "node_pool": "public-node-pool"
                },
                "min_cpu_platform": "",
                "oauth_scopes": [
                  "https://www.googleapis.com/auth/cloud-platform"
                ],
                "preemptible": false,
                "sandbox_config": [],
                "service_account": "public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
                "shielded_instance_config": [
                  {
                    "enable_integrity_monitoring": true,
                    "enable_secure_boot": false
                  }
                ],
                "tags": [
                  "gke-public-endpoint-cluster",
                  "gke-public-endpoint-cluster-public-node-pool"
                ],
                "taint": [],
                "workload_metadata_config": [
                  {
                    "node_metadata": "GKE_METADATA_SERVER"
                  }
                ]
              }
            ],
            "node_count": 3,
            "node_locations": [
              "northamerica-northeast1-a",
              "northamerica-northeast1-b",
              "northamerica-northeast1-c"
            ],
            "project": "alw-gke-106",
            "timeouts": {
              "create": "45m",
              "delete": "45m",
              "update": "45m"
            },
            "upgrade_settings": [
              {
                "max_surge": 1,
                "max_unavailable": 0
              }
            ],
            "version": "1.18.16-gke.502"
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoyNzAwMDAwMDAwMDAwLCJkZWxldGUiOjI3MDAwMDAwMDAwMDAsInVwZGF0ZSI6MjcwMDAwMDAwMDAwMH0sInNjaGVtYV92ZXJzaW9uIjoiMSJ9",
          "dependencies": [
            "data.google_client_openid_userinfo.me",
            "data.google_project.project",
            "data.template_file.startup_script",
            "module.bastion.google_compute_instance_from_template.bastion_vm",
            "module.bastion.google_project_iam_custom_role.compute_os_login_viewer",
            "module.bastion.google_project_iam_member.bastion_oslogin_bindings",
            "module.bastion.google_project_iam_member.bastion_sa_bindings",
            "module.bastion.google_service_account.bastion_host",
            "module.bastion.google_service_account_iam_binding.bastion_sa_user",
            "module.bastion.module.iap_tunneling.google_compute_firewall.allow_from_iap_to_instances",
            "module.bastion.module.iap_tunneling.google_iap_tunnel_instance_iam_binding.enable_iap",
            "module.bastion.module.instance_template.data.google_compute_image.image",
            "module.bastion.module.instance_template.data.google_compute_image.image_family",
            "module.bastion.module.instance_template.google_compute_instance_template.tpl",
            "module.bastion.random_id.random_role_id_suffix",
            "module.enabled_google_apis.google_project_service.project_services",
            "module.gke.module.gke.data.google_compute_zones.available",
            "module.gke.module.gke.data.google_container_engine_versions.region",
            "module.gke.module.gke.data.google_container_engine_versions.zone",
            "module.gke.module.gke.google_container_cluster.primary",
            "module.gke.module.gke.google_service_account.cluster_service_account",
            "module.gke.module.gke.random_shuffle.available_zones",
            "module.kms.google_kms_crypto_key.key",
            "module.kms.google_kms_crypto_key.key_ephemeral",
            "module.kms.google_kms_crypto_key_iam_binding.decrypters",
            "module.kms.google_kms_crypto_key_iam_binding.encrypters",
            "module.kms.google_kms_crypto_key_iam_binding.owners",
            "module.kms.google_kms_key_ring.key_ring",
            "module.service_accounts.data.template_file.keys",
            "module.service_accounts.google_billing_account_iam_member.billing_user",
            "module.service_accounts.google_organization_iam_member.billing_user",
            "module.service_accounts.google_organization_iam_member.organization_viewer",
            "module.service_accounts.google_organization_iam_member.xpn_admin",
            "module.service_accounts.google_project_iam_member.project-roles",
            "module.service_accounts.google_service_account.service_accounts",
            "module.service_accounts.google_service_account_key.keys",
            "module.vpc.module.subnets.google_compute_subnetwork.subnetwork",
            "module.vpc.module.vpc.google_compute_network.network",
            "random_id.kms"
          ]
        }
      ]
    },
    {
      "module": "module.gke.module.gke",
      "mode": "managed",
      "type": "random_shuffle",
      "name": "available_zones",
      "provider": "provider[\"registry.terraform.io/hashicorp/random\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "-",
            "input": [
              "northamerica-northeast1-a",
              "northamerica-northeast1-b",
              "northamerica-northeast1-c"
            ],
            "keepers": null,
            "result": [
              "northamerica-northeast1-a",
              "northamerica-northeast1-b",
              "northamerica-northeast1-c"
            ],
            "result_count": 3,
            "seed": null
          },
          "sensitive_attributes": [],
          "private": "bnVsbA==",
          "dependencies": [
            "data.google_client_openid_userinfo.me",
            "data.google_project.project",
            "data.template_file.startup_script",
            "module.bastion.google_compute_instance_from_template.bastion_vm",
            "module.bastion.google_project_iam_custom_role.compute_os_login_viewer",
            "module.bastion.google_project_iam_member.bastion_oslogin_bindings",
            "module.bastion.google_project_iam_member.bastion_sa_bindings",
            "module.bastion.google_service_account.bastion_host",
            "module.bastion.google_service_account_iam_binding.bastion_sa_user",
            "module.bastion.module.iap_tunneling.google_compute_firewall.allow_from_iap_to_instances",
            "module.bastion.module.iap_tunneling.google_iap_tunnel_instance_iam_binding.enable_iap",
            "module.bastion.module.instance_template.data.google_compute_image.image",
            "module.bastion.module.instance_template.data.google_compute_image.image_family",
            "module.bastion.module.instance_template.google_compute_instance_template.tpl",
            "module.bastion.random_id.random_role_id_suffix",
            "module.enabled_google_apis.google_project_service.project_services",
            "module.gke.module.gke.data.google_compute_zones.available",
            "module.kms.google_kms_crypto_key.key",
            "module.kms.google_kms_crypto_key.key_ephemeral",
            "module.kms.google_kms_crypto_key_iam_binding.decrypters",
            "module.kms.google_kms_crypto_key_iam_binding.encrypters",
            "module.kms.google_kms_crypto_key_iam_binding.owners",
            "module.kms.google_kms_key_ring.key_ring",
            "module.service_accounts.data.template_file.keys",
            "module.service_accounts.google_billing_account_iam_member.billing_user",
            "module.service_accounts.google_organization_iam_member.billing_user",
            "module.service_accounts.google_organization_iam_member.organization_viewer",
            "module.service_accounts.google_organization_iam_member.xpn_admin",
            "module.service_accounts.google_project_iam_member.project-roles",
            "module.service_accounts.google_service_account.service_accounts",
            "module.service_accounts.google_service_account_key.keys",
            "module.vpc.module.subnets.google_compute_subnetwork.subnetwork",
            "module.vpc.module.vpc.google_compute_network.network",
            "random_id.kms"
          ]
        }
      ]
    },
    {
      "module": "module.gke.module.gke",
      "mode": "managed",
      "type": "random_string",
      "name": "cluster_service_account_suffix",
      "provider": "provider[\"registry.terraform.io/hashicorp/random\"]",
      "instances": [
        {
          "schema_version": 1,
          "attributes": {
            "id": "77bx",
            "keepers": null,
            "length": 4,
            "lower": true,
            "min_lower": 0,
            "min_numeric": 0,
            "min_special": 0,
            "min_upper": 0,
            "number": true,
            "override_special": null,
            "result": "77bx",
            "special": false,
            "upper": false
          },
          "sensitive_attributes": [],
          "private": "eyJzY2hlbWFfdmVyc2lvbiI6IjEifQ==",
          "dependencies": [
            "data.google_client_openid_userinfo.me",
            "data.google_project.project",
            "data.template_file.startup_script",
            "module.bastion.google_compute_instance_from_template.bastion_vm",
            "module.bastion.google_project_iam_custom_role.compute_os_login_viewer",
            "module.bastion.google_project_iam_member.bastion_oslogin_bindings",
            "module.bastion.google_project_iam_member.bastion_sa_bindings",
            "module.bastion.google_service_account.bastion_host",
            "module.bastion.google_service_account_iam_binding.bastion_sa_user",
            "module.bastion.module.iap_tunneling.google_compute_firewall.allow_from_iap_to_instances",
            "module.bastion.module.iap_tunneling.google_iap_tunnel_instance_iam_binding.enable_iap",
            "module.bastion.module.instance_template.data.google_compute_image.image",
            "module.bastion.module.instance_template.data.google_compute_image.image_family",
            "module.bastion.module.instance_template.google_compute_instance_template.tpl",
            "module.bastion.random_id.random_role_id_suffix",
            "module.enabled_google_apis.google_project_service.project_services",
            "module.kms.google_kms_crypto_key.key",
            "module.kms.google_kms_crypto_key.key_ephemeral",
            "module.kms.google_kms_crypto_key_iam_binding.decrypters",
            "module.kms.google_kms_crypto_key_iam_binding.encrypters",
            "module.kms.google_kms_crypto_key_iam_binding.owners",
            "module.kms.google_kms_key_ring.key_ring",
            "module.service_accounts.data.template_file.keys",
            "module.service_accounts.google_billing_account_iam_member.billing_user",
            "module.service_accounts.google_organization_iam_member.billing_user",
            "module.service_accounts.google_organization_iam_member.organization_viewer",
            "module.service_accounts.google_organization_iam_member.xpn_admin",
            "module.service_accounts.google_project_iam_member.project-roles",
            "module.service_accounts.google_service_account.service_accounts",
            "module.service_accounts.google_service_account_key.keys",
            "module.vpc.module.subnets.google_compute_subnetwork.subnetwork",
            "module.vpc.module.vpc.google_compute_network.network",
            "random_id.kms"
          ]
        }
      ]
    },
    {
      "module": "module.gke.module.gke.module.gcloud_delete_default_kube_dns_configmap.module.gcloud_kubectl",
      "mode": "managed",
      "type": "null_resource",
      "name": "module_depends_on",
      "provider": "provider[\"registry.terraform.io/hashicorp/null\"]",
      "instances": [
        {
          "index_key": 0,
          "schema_version": 0,
          "attributes": {
            "id": "6720514004174576472",
            "triggers": {
              "value": "3"
            }
          },
          "sensitive_attributes": [],
          "private": "bnVsbA==",
          "dependencies": [
            "data.google_client_openid_userinfo.me",
            "data.google_project.project",
            "data.template_file.startup_script",
            "module.bastion.google_compute_instance_from_template.bastion_vm",
            "module.bastion.google_project_iam_custom_role.compute_os_login_viewer",
            "module.bastion.google_project_iam_member.bastion_oslogin_bindings",
            "module.bastion.google_project_iam_member.bastion_sa_bindings",
            "module.bastion.google_service_account.bastion_host",
            "module.bastion.google_service_account_iam_binding.bastion_sa_user",
            "module.bastion.module.iap_tunneling.google_compute_firewall.allow_from_iap_to_instances",
            "module.bastion.module.iap_tunneling.google_iap_tunnel_instance_iam_binding.enable_iap",
            "module.bastion.module.instance_template.data.google_compute_image.image",
            "module.bastion.module.instance_template.data.google_compute_image.image_family",
            "module.bastion.module.instance_template.google_compute_instance_template.tpl",
            "module.bastion.random_id.random_role_id_suffix",
            "module.enabled_google_apis.google_project_service.project_services",
            "module.gke.module.gke.data.google_client_config.default",
            "module.gke.module.gke.data.google_compute_zones.available",
            "module.gke.module.gke.data.google_container_engine_versions.region",
            "module.gke.module.gke.data.google_container_engine_versions.zone",
            "module.gke.module.gke.google_container_cluster.primary",
            "module.gke.module.gke.google_container_node_pool.pools",
            "module.gke.module.gke.google_service_account.cluster_service_account",
            "module.gke.module.gke.random_shuffle.available_zones",
            "module.kms.google_kms_crypto_key.key",
            "module.kms.google_kms_crypto_key.key_ephemeral",
            "module.kms.google_kms_crypto_key_iam_binding.decrypters",
            "module.kms.google_kms_crypto_key_iam_binding.encrypters",
            "module.kms.google_kms_crypto_key_iam_binding.owners",
            "module.kms.google_kms_key_ring.key_ring",
            "module.service_accounts.data.template_file.keys",
            "module.service_accounts.google_billing_account_iam_member.billing_user",
            "module.service_accounts.google_organization_iam_member.billing_user",
            "module.service_accounts.google_organization_iam_member.organization_viewer",
            "module.service_accounts.google_organization_iam_member.xpn_admin",
            "module.service_accounts.google_project_iam_member.project-roles",
            "module.service_accounts.google_service_account.service_accounts",
            "module.service_accounts.google_service_account_key.keys",
            "module.vpc.module.subnets.google_compute_subnetwork.subnetwork",
            "module.vpc.module.vpc.google_compute_network.network",
            "random_id.kms"
          ]
        }
      ]
    },
    {
      "module": "module.service_accounts",
      "mode": "data",
      "type": "template_file",
      "name": "keys",
      "provider": "provider[\"registry.terraform.io/hashicorp/template\"]",
      "instances": [
        {
          "index_key": "public-endpoint-cluster-sa",
          "schema_version": 0,
          "attributes": {
            "filename": null,
            "id": "4b2f14f9f6b7abc8dd30287abe98dc3802da8c3901ee5a205761666879213bec",
            "rendered": "{\n  \"type\": \"service_account\",\n  \"project_id\": \"alw-gke-106\",\n  \"private_key_id\": \"ece86acfbc166536d5594285bf565c4f6f6e17f1\",\n  \"private_key\": \"-----BEGIN PRIVATE KEY-----\\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCSrNpxEfyFs0Jd\\nki+jIErX5WRVFDPe6rwOLgLLBu2iMwUt6kQCH8GZds+V4Muf6X7rufCFXeVWv5XO\\nRLNGvv5pkyYgIQLca/sgaLtmlweuLthba0w124uyptOwq2Z7NX0JISKnFsUWrfWn\\n0An+cxt0VaiBCAIi9d4PATK470tqzFa/w7C7gxKDbUUWHRkF4GyaCD4AG7dnr3Og\\nktVZUVg4EMTp54xJtBaRnXhwgHUShjWxNodzmfB8iqAAVg88vB5BWOEKg8MAELUi\\n4k3NWn7IAUlz0lNpawuDACFw6knrzENjl4wdQz82WUYIgRFxrlc+ACO7Jay6v3mM\\n92vFY1nPAgMBAAECggEARBpRJM36p6OnjWXKi537Uko270/9k6P/JEBV2KoDXVv+\\nLCcJY8kV7akeUpN5SGs0nMQNewcxbLlxF8CLUy5sV13VBnb9apYSmKY4WTaIAObM\\nW4oy7RDeyNkwEmhLIasgvsPtYJKweUrVdJEiiswsc7QwFJVA1LW/YM0oHXkyVcgO\\nDdtmiusS70aCsGsrjCdfl4EovNJKncJGIyjdAvJ8HQ/Qat6MSl1Prefghr2eRvrM\\nnWinu/nYzKjSxaNMmXyXIMpaqhElUvQR+2an7U6cV5NfVJu0sBqSknOtY+0gHrga\\nOusYLgdYKVeom+Lr6R7ZkscrnBKS76QnWepYs0NdYQKBgQDDNbqPXaTHjKb4tMqV\\n0P8h4uMzuy3cviNj873TnGlH6zPIzsy6lC3SNR7CebM9o8QBETAZd2m7YnEdliWk\\nmWXoqNzJmflzze+fRqNNdfyoWq2nXoWZE34P7LnA37a5q1Z6VPOnf0j0awtGH0VA\\n+vnWxycoa7V/yd7c+bPGEo2K4QKBgQDAWefpszqN06BCgQgb9ftT4vCo0IP5aTXh\\nZoz/2uLHpWnnsdWmuWKYlLavwAp5jqBBKr4zFu6kunLCFXiCQTuClT70mj2HsRW3\\nRkOgK24Pg+4pcDaai4FVi7tBLYZ/Unl0Leu5xOu3GaFUaOUP84ISxY+L6LPg0b2T\\ngoENTWiqrwKBgFHe0NWb8qX2aXjZajWXJ8mwfJWPpVZ1MCaVbUG40bbmABvyD48Y\\n4nbM7I+ntvLdIjFIYiHsIR4D1WkRNcxowYLof2DWAPb+ocbtO0QbfdGl5jrRu7pN\\noItRPz6TFPGd2HEJ+/59tb08v8ezCbqNCAd6EwQy2DY2FhAbcbhaw55BAoGBAL5U\\nN/Y3MqlDzkAADVYdgCLxW9CvAue4A2iVYM+Kdvu14aUxgocGyVjRTjN5guPlDQ1u\\njeVfu6OkGgmR1TyN76S2qSS/ukKaJzLChAfo8W7IzNCUCHPDtqY/LXrA4WT65tLe\\n3XFkORlkcw5i/MVb3klU00VNbS/4We2sJKZVAkxhAoGAQPHIdVYfuYuqxaTFl5re\\nPxwgOPo6CSpIMlg29sZmBjeItswfs9gntgyG1vDDqT5NaqniRdxVcs699xCSG71Z\\ncKLaTLjs4LiUc+GVkzCT36bca58vsBUYvKd7IeO9eSB6rZhO7qvplwY5+nej0sq6\\nti5Zc51ny0l8qGk7aPPDliM=\\n-----END PRIVATE KEY-----\\n\",\n  \"client_email\": \"public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com\",\n  \"client_id\": \"112059659940349741214\",\n  \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\",\n  \"token_uri\": \"https://oauth2.googleapis.com/token\",\n  \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\",\n  \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/public-endpoint-cluster-sa%40alw-gke-106.iam.gserviceaccount.com\"\n}\n",
            "template": "${key}",
            "vars": {
              "key": "{\n  \"type\": \"service_account\",\n  \"project_id\": \"alw-gke-106\",\n  \"private_key_id\": \"ece86acfbc166536d5594285bf565c4f6f6e17f1\",\n  \"private_key\": \"-----BEGIN PRIVATE KEY-----\\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCSrNpxEfyFs0Jd\\nki+jIErX5WRVFDPe6rwOLgLLBu2iMwUt6kQCH8GZds+V4Muf6X7rufCFXeVWv5XO\\nRLNGvv5pkyYgIQLca/sgaLtmlweuLthba0w124uyptOwq2Z7NX0JISKnFsUWrfWn\\n0An+cxt0VaiBCAIi9d4PATK470tqzFa/w7C7gxKDbUUWHRkF4GyaCD4AG7dnr3Og\\nktVZUVg4EMTp54xJtBaRnXhwgHUShjWxNodzmfB8iqAAVg88vB5BWOEKg8MAELUi\\n4k3NWn7IAUlz0lNpawuDACFw6knrzENjl4wdQz82WUYIgRFxrlc+ACO7Jay6v3mM\\n92vFY1nPAgMBAAECggEARBpRJM36p6OnjWXKi537Uko270/9k6P/JEBV2KoDXVv+\\nLCcJY8kV7akeUpN5SGs0nMQNewcxbLlxF8CLUy5sV13VBnb9apYSmKY4WTaIAObM\\nW4oy7RDeyNkwEmhLIasgvsPtYJKweUrVdJEiiswsc7QwFJVA1LW/YM0oHXkyVcgO\\nDdtmiusS70aCsGsrjCdfl4EovNJKncJGIyjdAvJ8HQ/Qat6MSl1Prefghr2eRvrM\\nnWinu/nYzKjSxaNMmXyXIMpaqhElUvQR+2an7U6cV5NfVJu0sBqSknOtY+0gHrga\\nOusYLgdYKVeom+Lr6R7ZkscrnBKS76QnWepYs0NdYQKBgQDDNbqPXaTHjKb4tMqV\\n0P8h4uMzuy3cviNj873TnGlH6zPIzsy6lC3SNR7CebM9o8QBETAZd2m7YnEdliWk\\nmWXoqNzJmflzze+fRqNNdfyoWq2nXoWZE34P7LnA37a5q1Z6VPOnf0j0awtGH0VA\\n+vnWxycoa7V/yd7c+bPGEo2K4QKBgQDAWefpszqN06BCgQgb9ftT4vCo0IP5aTXh\\nZoz/2uLHpWnnsdWmuWKYlLavwAp5jqBBKr4zFu6kunLCFXiCQTuClT70mj2HsRW3\\nRkOgK24Pg+4pcDaai4FVi7tBLYZ/Unl0Leu5xOu3GaFUaOUP84ISxY+L6LPg0b2T\\ngoENTWiqrwKBgFHe0NWb8qX2aXjZajWXJ8mwfJWPpVZ1MCaVbUG40bbmABvyD48Y\\n4nbM7I+ntvLdIjFIYiHsIR4D1WkRNcxowYLof2DWAPb+ocbtO0QbfdGl5jrRu7pN\\noItRPz6TFPGd2HEJ+/59tb08v8ezCbqNCAd6EwQy2DY2FhAbcbhaw55BAoGBAL5U\\nN/Y3MqlDzkAADVYdgCLxW9CvAue4A2iVYM+Kdvu14aUxgocGyVjRTjN5guPlDQ1u\\njeVfu6OkGgmR1TyN76S2qSS/ukKaJzLChAfo8W7IzNCUCHPDtqY/LXrA4WT65tLe\\n3XFkORlkcw5i/MVb3klU00VNbS/4We2sJKZVAkxhAoGAQPHIdVYfuYuqxaTFl5re\\nPxwgOPo6CSpIMlg29sZmBjeItswfs9gntgyG1vDDqT5NaqniRdxVcs699xCSG71Z\\ncKLaTLjs4LiUc+GVkzCT36bca58vsBUYvKd7IeO9eSB6rZhO7qvplwY5+nej0sq6\\nti5Zc51ny0l8qGk7aPPDliM=\\n-----END PRIVATE KEY-----\\n\",\n  \"client_email\": \"public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com\",\n  \"client_id\": \"112059659940349741214\",\n  \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\",\n  \"token_uri\": \"https://oauth2.googleapis.com/token\",\n  \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\",\n  \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/public-endpoint-cluster-sa%40alw-gke-106.iam.gserviceaccount.com\"\n}\n"
            }
          },
          "sensitive_attributes": []
        }
      ]
    },
    {
      "module": "module.service_accounts",
      "mode": "managed",
      "type": "google_project_iam_member",
      "name": "project-roles",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "index_key": "public-endpoint-cluster-sa-alw-gke-106=\u003eroles/artifactregistry.reader",
          "schema_version": 0,
          "attributes": {
            "condition": [],
            "etag": "BwXAkDizl0U=",
            "id": "alw-gke-106/roles/artifactregistry.reader/serviceaccount:public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "member": "serviceAccount:public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "project": "alw-gke-106",
            "role": "roles/artifactregistry.reader"
          },
          "sensitive_attributes": [],
          "private": "bnVsbA==",
          "dependencies": [
            "module.enabled_google_apis.google_project_service.project_services",
            "module.service_accounts.google_service_account.service_accounts"
          ]
        },
        {
          "index_key": "public-endpoint-cluster-sa-alw-gke-106=\u003eroles/logging.logWriter",
          "schema_version": 0,
          "attributes": {
            "condition": [],
            "etag": "BwXAkDizl0U=",
            "id": "alw-gke-106/roles/logging.logWriter/serviceaccount:public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "member": "serviceAccount:public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "project": "alw-gke-106",
            "role": "roles/logging.logWriter"
          },
          "sensitive_attributes": [],
          "private": "bnVsbA==",
          "dependencies": [
            "module.enabled_google_apis.google_project_service.project_services",
            "module.service_accounts.google_service_account.service_accounts"
          ]
        },
        {
          "index_key": "public-endpoint-cluster-sa-alw-gke-106=\u003eroles/monitoring.metricWriter",
          "schema_version": 0,
          "attributes": {
            "condition": [],
            "etag": "BwXAkDizl0U=",
            "id": "alw-gke-106/roles/monitoring.metricWriter/serviceaccount:public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "member": "serviceAccount:public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "project": "alw-gke-106",
            "role": "roles/monitoring.metricWriter"
          },
          "sensitive_attributes": [],
          "private": "bnVsbA==",
          "dependencies": [
            "module.enabled_google_apis.google_project_service.project_services",
            "module.service_accounts.google_service_account.service_accounts"
          ]
        },
        {
          "index_key": "public-endpoint-cluster-sa-alw-gke-106=\u003eroles/monitoring.viewer",
          "schema_version": 0,
          "attributes": {
            "condition": [],
            "etag": "BwXAkDizl0U=",
            "id": "alw-gke-106/roles/monitoring.viewer/serviceaccount:public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "member": "serviceAccount:public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "project": "alw-gke-106",
            "role": "roles/monitoring.viewer"
          },
          "sensitive_attributes": [],
          "private": "bnVsbA==",
          "dependencies": [
            "module.enabled_google_apis.google_project_service.project_services",
            "module.service_accounts.google_service_account.service_accounts"
          ]
        },
        {
          "index_key": "public-endpoint-cluster-sa-alw-gke-106=\u003eroles/stackdriver.resourceMetadata.writer",
          "schema_version": 0,
          "attributes": {
            "condition": [],
            "etag": "BwXAkDizl0U=",
            "id": "alw-gke-106/roles/stackdriver.resourceMetadata.writer/serviceaccount:public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "member": "serviceAccount:public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "project": "alw-gke-106",
            "role": "roles/stackdriver.resourceMetadata.writer"
          },
          "sensitive_attributes": [],
          "private": "bnVsbA==",
          "dependencies": [
            "module.enabled_google_apis.google_project_service.project_services",
            "module.service_accounts.google_service_account.service_accounts"
          ]
        },
        {
          "index_key": "public-endpoint-cluster-sa-alw-gke-106=\u003eroles/storage.objectViewer",
          "schema_version": 0,
          "attributes": {
            "condition": [],
            "etag": "BwXAkDizl0U=",
            "id": "alw-gke-106/roles/storage.objectViewer/serviceaccount:public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "member": "serviceAccount:public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "project": "alw-gke-106",
            "role": "roles/storage.objectViewer"
          },
          "sensitive_attributes": [],
          "private": "bnVsbA==",
          "dependencies": [
            "module.enabled_google_apis.google_project_service.project_services",
            "module.service_accounts.google_service_account.service_accounts"
          ]
        }
      ]
    },
    {
      "module": "module.service_accounts",
      "mode": "managed",
      "type": "google_service_account",
      "name": "service_accounts",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "index_key": "public-endpoint-cluster-sa",
          "schema_version": 0,
          "attributes": {
            "account_id": "public-endpoint-cluster-sa",
            "description": "",
            "display_name": "GKE cluster service account",
            "email": "public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "id": "projects/alw-gke-106/serviceAccounts/public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "name": "projects/alw-gke-106/serviceAccounts/public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "project": "alw-gke-106",
            "timeouts": null,
            "unique_id": "112059659940349741214"
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjozMDAwMDAwMDAwMDB9fQ==",
          "dependencies": [
            "module.enabled_google_apis.google_project_service.project_services"
          ]
        }
      ]
    },
    {
      "module": "module.service_accounts",
      "mode": "managed",
      "type": "google_service_account_key",
      "name": "keys",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "index_key": "public-endpoint-cluster-sa",
          "schema_version": 0,
          "attributes": {
            "id": "projects/alw-gke-106/serviceAccounts/public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com/keys/ece86acfbc166536d5594285bf565c4f6f6e17f1",
            "keepers": null,
            "key_algorithm": "KEY_ALG_RSA_2048",
            "name": "projects/alw-gke-106/serviceAccounts/public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com/keys/ece86acfbc166536d5594285bf565c4f6f6e17f1",
            "private_key": "ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAiYWx3LWdrZS0xMDYiLAogICJwcml2YXRlX2tleV9pZCI6ICJlY2U4NmFjZmJjMTY2NTM2ZDU1OTQyODViZjU2NWM0ZjZmNmUxN2YxIiwKICAicHJpdmF0ZV9rZXkiOiAiLS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tXG5NSUlFdlFJQkFEQU5CZ2txaGtpRzl3MEJBUUVGQUFTQ0JLY3dnZ1NqQWdFQUFvSUJBUUNTck5weEVmeUZzMEpkXG5raStqSUVyWDVXUlZGRFBlNnJ3T0xnTExCdTJpTXdVdDZrUUNIOEdaZHMrVjRNdWY2WDdydWZDRlhlVld2NVhPXG5STE5HdnY1cGt5WWdJUUxjYS9zZ2FMdG1sd2V1THRoYmEwdzEyNHV5cHRPd3EyWjdOWDBKSVNLbkZzVVdyZlduXG4wQW4rY3h0MFZhaUJDQUlpOWQ0UEFUSzQ3MHRxekZhL3c3QzdneEtEYlVVV0hSa0Y0R3lhQ0Q0QUc3ZG5yM09nXG5rdFZaVVZnNEVNVHA1NHhKdEJhUm5YaHdnSFVTaGpXeE5vZHptZkI4aXFBQVZnODh2QjVCV09FS2c4TUFFTFVpXG40azNOV243SUFVbHowbE5wYXd1REFDRnc2a25yekVOamw0d2RRejgyV1VZSWdSRnhybGMrQUNPN0pheTZ2M21NXG45MnZGWTFuUEFnTUJBQUVDZ2dFQVJCcFJKTTM2cDZPbmpXWEtpNTM3VWtvMjcwLzlrNlAvSkVCVjJLb0RYVnYrXG5MQ2NKWThrVjdha2VVcE41U0dzMG5NUU5ld2N4YkxseEY4Q0xVeTVzVjEzVkJuYjlhcFlTbUtZNFdUYUlBT2JNXG5XNG95N1JEZXlOa3dFbWhMSWFzZ3ZzUHRZSkt3ZVVyVmRKRWlpc3dzYzdRd0ZKVkExTFcvWU0wb0hYa3lWY2dPXG5EZHRtaXVzUzcwYUNzR3NyakNkZmw0RW92TkpLbmNKR0l5amRBdko4SFEvUWF0Nk1TbDFQcmVmZ2hyMmVSdnJNXG5uV2ludS9uWXpLalN4YU5NbVh5WElNcGFxaEVsVXZRUisyYW43VTZjVjVOZlZKdTBzQnFTa25PdFkrMGdIcmdhXG5PdXNZTGdkWUtWZW9tK0xyNlI3WmtzY3JuQktTNzZRbldlcFlzME5kWVFLQmdRREROYnFQWGFUSGpLYjR0TXFWXG4wUDhoNHVNenV5M2N2aU5qODczVG5HbEg2elBJenN5NmxDM1NOUjdDZWJNOW84UUJFVEFaZDJtN1luRWRsaVdrXG5tV1hvcU56Sm1mbHp6ZStmUnFOTmRmeW9XcTJuWG9XWkUzNFA3TG5BMzdhNXExWjZWUE9uZjBqMGF3dEdIMFZBXG4rdm5XeHljb2E3Vi95ZDdjK2JQR0VvMks0UUtCZ1FEQVdlZnBzenFOMDZCQ2dRZ2I5ZnRUNHZDbzBJUDVhVFhoXG5ab3ovMnVMSHBXbm5zZFdtdVdLWWxMYXZ3QXA1anFCQktyNHpGdTZrdW5MQ0ZYaUNRVHVDbFQ3MG1qMkhzUlczXG5Sa09nSzI0UGcrNHBjRGFhaTRGVmk3dEJMWVovVW5sMExldTV4T3UzR2FGVWFPVVA4NElTeFkrTDZMUGcwYjJUXG5nb0VOVFdpcXJ3S0JnRkhlME5XYjhxWDJhWGpaYWpXWEo4bXdmSldQcFZaMU1DYVZiVUc0MGJibUFCdnlENDhZXG40bmJNN0krbnR2TGRJakZJWWlIc0lSNEQxV2tSTmN4b3dZTG9mMkRXQVBiK29jYnRPMFFiZmRHbDVqclJ1N3BOXG5vSXRSUHo2VEZQR2QySEVKKy81OXRiMDh2OGV6Q2JxTkNBZDZFd1F5MkRZMkZoQWJjYmhhdzU1QkFvR0JBTDVVXG5OL1kzTXFsRHprQUFEVllkZ0NMeFc5Q3ZBdWU0QTJpVllNK0tkdnUxNGFVeGdvY0d5VmpSVGpONWd1UGxEUTF1XG5qZVZmdTZPa0dnbVIxVHlONzZTMnFTUy91a0thSnpMQ2hBZm84VzdJek5DVUNIUER0cVkvTFhyQTRXVDY1dExlXG4zWEZrT1Jsa2N3NWkvTVZiM2tsVTAwVk5iUy80V2Uyc0pLWlZBa3hoQW9HQVFQSElkVllmdVl1cXhhVEZsNXJlXG5QeHdnT1BvNkNTcElNbGcyOXNabUJqZUl0c3dmczlnbnRneUcxdkREcVQ1TmFxbmlSZHhWY3M2OTl4Q1NHNzFaXG5jS0xhVExqczRMaVVjK0dWa3pDVDM2YmNhNTh2c0JVWXZLZDdJZU85ZVNCNnJaaE83cXZwbHdZNStuZWowc3E2XG50aTVaYzUxbnkwbDhxR2s3YVBQRGxpTT1cbi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS1cbiIsCiAgImNsaWVudF9lbWFpbCI6ICJwdWJsaWMtZW5kcG9pbnQtY2x1c3Rlci1zYUBhbHctZ2tlLTEwNi5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsCiAgImNsaWVudF9pZCI6ICIxMTIwNTk2NTk5NDAzNDk3NDEyMTQiLAogICJhdXRoX3VyaSI6ICJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vby9vYXV0aDIvYXV0aCIsCiAgInRva2VuX3VyaSI6ICJodHRwczovL29hdXRoMi5nb29nbGVhcGlzLmNvbS90b2tlbiIsCiAgImF1dGhfcHJvdmlkZXJfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9vYXV0aDIvdjEvY2VydHMiLAogICJjbGllbnRfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9yb2JvdC92MS9tZXRhZGF0YS94NTA5L3B1YmxpYy1lbmRwb2ludC1jbHVzdGVyLXNhJTQwYWx3LWdrZS0xMDYuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iCn0K",
            "private_key_type": "TYPE_GOOGLE_CREDENTIALS_FILE",
            "public_key": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvRENDQWVTZ0F3SUJBZ0lJT2hvTmFYNmNNL3N3RFFZSktvWklodmNOQVFFRkJRQXdJREVlTUJ3R0ExVUUKQXhNVk1URXlNRFU1TmpVNU9UUXdNelE1TnpReE1qRTBNQ0FYRFRJeE1EUXlNakUwTURnMU9Wb1lEems1T1RreApNak14TWpNMU9UVTVXakFnTVI0d0hBWURWUVFERXhVeE1USXdOVGsyTlRrNU5EQXpORGszTkRFeU1UUXdnZ0VpCk1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRQ1NyTnB4RWZ5RnMwSmRraStqSUVyWDVXUlYKRkRQZTZyd09MZ0xMQnUyaU13VXQ2a1FDSDhHWmRzK1Y0TXVmNlg3cnVmQ0ZYZVZXdjVYT1JMTkd2djVwa3lZZwpJUUxjYS9zZ2FMdG1sd2V1THRoYmEwdzEyNHV5cHRPd3EyWjdOWDBKSVNLbkZzVVdyZlduMEFuK2N4dDBWYWlCCkNBSWk5ZDRQQVRLNDcwdHF6RmEvdzdDN2d4S0RiVVVXSFJrRjRHeWFDRDRBRzdkbnIzT2drdFZaVVZnNEVNVHAKNTR4SnRCYVJuWGh3Z0hVU2hqV3hOb2R6bWZCOGlxQUFWZzg4dkI1QldPRUtnOE1BRUxVaTRrM05XbjdJQVVsegowbE5wYXd1REFDRnc2a25yekVOamw0d2RRejgyV1VZSWdSRnhybGMrQUNPN0pheTZ2M21NOTJ2RlkxblBBZ01CCkFBR2pPREEyTUF3R0ExVWRFd0VCL3dRQ01BQXdEZ1lEVlIwUEFRSC9CQVFEQWdlQU1CWUdBMVVkSlFFQi93UU0KTUFvR0NDc0dBUVVGQndNQ01BMEdDU3FHU0liM0RRRUJCUVVBQTRJQkFRQXVnMEw0ZVBXQ05QdnZwSnVBZlR3bwpjWEZQcmU3U2pkUjhsY1dWQlZUTnpMTTNSR081UmVVeGVLdFgybVpUeWZpNGcrWnBYTGdLTTNJbnY4SW9BY01RCjQwNWNVYjd6SkY3Y21CaXNwM1FzclUyTDd5WUw0RUJEM3pTb1JaT1l2QlFndW41bGdDRlRUUFNoYjhLcG4wYlIKMTc0Z3pVOHhCMk9FcjduSG5FTFVqbGtMSUtHekRGeU9RMnlvM3hUaU9talAzNXVQOHNzWGt3VURxS1ZmbnNmSAplbTYrTWlBZnBoMkJFbTQwYUUzbGhSNmM5aCtpcjF5WjdpQVgvcDRqdW1udkxjU2R2YnF6MTQzU3RtZVhBM3Z6CkVCN1JUOUhMdVBzMVB2NVh0dE4wNHlsV1VyQ2FobzkzVFNsYTlXYWhxY1R5U0NaTXo4OGhKOExIclQ0QmRTcHUKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=",
            "public_key_data": null,
            "public_key_type": "TYPE_X509_PEM_FILE",
            "service_account_id": "public-endpoint-cluster-sa@alw-gke-106.iam.gserviceaccount.com",
            "valid_after": "2021-04-22T14:08:59Z",
            "valid_before": "9999-12-31T23:59:59Z"
          },
          "sensitive_attributes": [],
          "private": "bnVsbA==",
          "dependencies": [
            "module.enabled_google_apis.google_project_service.project_services",
            "module.service_accounts.google_service_account.service_accounts"
          ]
        }
      ]
    },
    {
      "module": "module.vpc.module.subnets",
      "mode": "managed",
      "type": "google_compute_subnetwork",
      "name": "subnetwork",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "index_key": "northamerica-northeast1/public-cluster-subnet",
          "schema_version": 0,
          "attributes": {
            "creation_timestamp": "2021-04-22T07:09:20.273-07:00",
            "description": "This subnet is managed by Terraform",
            "fingerprint": null,
            "gateway_address": "10.10.10.1",
            "id": "projects/alw-gke-106/regions/northamerica-northeast1/subnetworks/public-cluster-subnet",
            "ip_cidr_range": "10.10.10.0/24",
            "log_config": [],
            "name": "public-cluster-subnet",
            "network": "https://www.googleapis.com/compute/v1/projects/alw-gke-106/global/networks/public-cluster-network",
            "private_ip_google_access": true,
            "private_ipv6_google_access": "DISABLE_GOOGLE_ACCESS",
            "project": "alw-gke-106",
            "region": "northamerica-northeast1",
            "secondary_ip_range": [
              {
                "ip_cidr_range": "10.10.64.0/18",
                "range_name": "ip-range-pods"
              },
              {
                "ip_cidr_range": "10.10.192.0/18",
                "range_name": "ip-range-svc"
              }
            ],
            "self_link": "https://www.googleapis.com/compute/v1/projects/alw-gke-106/regions/northamerica-northeast1/subnetworks/public-cluster-subnet",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjozNjAwMDAwMDAwMDAsImRlbGV0ZSI6MzYwMDAwMDAwMDAwLCJ1cGRhdGUiOjM2MDAwMDAwMDAwMH19",
          "dependencies": [
            "module.enabled_google_apis.google_project_service.project_services",
            "module.vpc.module.vpc.google_compute_network.network"
          ]
        }
      ]
    },
    {
      "module": "module.vpc.module.vpc",
      "mode": "managed",
      "type": "google_compute_network",
      "name": "network",
      "provider": "provider[\"registry.terraform.io/hashicorp/google\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "auto_create_subnetworks": false,
            "delete_default_routes_on_create": false,
            "description": "",
            "gateway_ipv4": "",
            "id": "projects/alw-gke-106/global/networks/public-cluster-network",
            "mtu": 0,
            "name": "public-cluster-network",
            "project": "alw-gke-106",
            "routing_mode": "GLOBAL",
            "self_link": "https://www.googleapis.com/compute/v1/projects/alw-gke-106/global/networks/public-cluster-network",
            "timeouts": null
          },
          "sensitive_attributes": [],
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoyNDAwMDAwMDAwMDAsImRlbGV0ZSI6MjQwMDAwMDAwMDAwLCJ1cGRhdGUiOjI0MDAwMDAwMDAwMH19",
          "dependencies": [
            "module.enabled_google_apis.google_project_service.project_services"
          ]
        }
      ]
    }
  ]
}
