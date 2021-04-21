{
  "version": 4,
  "terraform_version": "0.14.9",
  "serial": 39,
  "lineage": "29de9076-989c-8ee7-0185-07077892776f",
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
      "value": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURLekNDQWhPZ0F3SUJBZ0lSQUtMekw2cCtuejdOTGV3RDJhc0NQaVl3RFFZSktvWklodmNOQVFFTEJRQXcKTHpFdE1Dc0dBMVVFQXhNa1pqWmlNREJpT0RNdFptUmhPUzAwTjJJMExUZ3dNVGN0TTJNek0yUm1NRGt3WXpSaApNQjRYRFRJeE1EUXlNVEU1TWpReU1Wb1hEVEkyTURReU1ESXdNalF5TVZvd0x6RXRNQ3NHQTFVRUF4TWtaalppCk1EQmlPRE10Wm1SaE9TMDBOMkkwTFRnd01UY3RNMk16TTJSbU1Ea3dZelJoTUlJQklqQU5CZ2txaGtpRzl3MEIKQVFFRkFBT0NBUThBTUlJQkNnS0NBUUVBMFJtNTB1VWs0Rm1FaU9waEJxZ2c3dHBHR3VxSGNaSnhEYU9vWEVFTgo2QkkwQkIzKzRkVFFIVWdYd3N0N0hySVZmckFFdld5d0VLdFJ5aG40ZnNGRFQ3TWxCRTF0MkVuWTdhUm5GcnoyCmkxM0ljeDgrUG5CTnZPUHBvZG50V0ROVjlQM3dYaVhiS3pEWlR0T3FqWWI5ZktNY21xeEZ5d2FyMllRNVhBQWoKTTdGbFl2dmlrOXFNN244V1ZHRUJ4cytHYjdrY2g1eGluQWlZaks0M0QwN0lITWVrUGZ3bzdkWlZoY0hVZ2Z3TAo4cVZPZEd2R3Y5WHFPdmZYQ3RNZitzWFVrYjFDWmJxcjFPaTBrSFRRRzFwaTU4V2pMRUFBREdaZ1YyVEN2TTJECnQwWDdva09zY0ZBejZNOU80UVZWenM0aWZOTjhZTTJNMS9pK1AydWxSSWU3QndJREFRQUJvMEl3UURBT0JnTlYKSFE4QkFmOEVCQU1DQWdRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVVA3WkVTRXB6ZWRKNApWamdsMTBxOVpNVzBtQlV3RFFZSktvWklodmNOQVFFTEJRQURnZ0VCQUk0bFJFdE5OM1BSbkpEOUNQOEVOMlQ2CkpsYmY4d0Uwem1nTzc2MzhtMFcvWE42VFc1bmVwZEQ2UnUySHVVcGlScEY2YW51Q2RvSXZHU0VOeEdiS3BmaWgKdFdvZGdya3VDOWU3VVVIM3lVWklQNGM4bTdySEtmTlZHL0FhNXFMSFJDaUtoeFNnVnArTjYvNGQ0aEplNVcxbgp5eE1BYzJLOXVraHE4dGd2TnN6V0tWVFI0b0NVL1NBamdoT3Vtb0Q3K3NhSFAvVGFCQ2hlcm1NRGF1a2QxcmxPCngySVlmSWZUTkJRL0JYcWR0cGJsWkF1dDVWa2Z6TEdmVFpZa0RPYUhCTEo3dk5lc09TV2s0cUYvMS8xTkQwUjQKeEMwNytNdkNJNlFkZmpybDdRb3N6RmhQNDlKSG8rL0hGaUVwN2VkbW81WG5kd3puVnRjMEZNY2dadlpVMm5NPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",
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
      "value": "gcloud container clusters get-credentials --project alw-gke-103 --zone northamerica-northeast1 public-endpoint-cluster",
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
            "access_token": "ya29.a0AfH6SMDbWChp0qLqQLNfwbRdS-B1SoqkVHBe36PIrbVFSiYg5HV3cy_dotgdN8EJIBTA_frOKWseFOAGacWOFD9o-mgAT-PK_mjUlrPD4YWEtP_EFjSg9_4XtaqaoFUiVkcVs1DfLVGJWXI6xyYZzqis-oJVkVc63Gjm7gGK_D0-9t-NUS84KUcPuw1WjbQlGltTcaaDFjw1X4qIlCfzcqPe8qL0KsYQrA9LZ7PtJVErprCKGw4MzE5IspZOs-vibBBkVw",
            "id": "projects/alw-gke-103/regions//zones/",
            "project": "alw-gke-103",
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
            "id": "projects/alw-gke-103",
            "labels": {},
            "name": "alw-gke-103",
            "number": "480256107416",
            "org_id": "920109858128",
            "project_id": "alw-gke-103",
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
            "b64_std": "eQA=",
            "b64_url": "eQA",
            "byte_length": 2,
            "dec": "30976",
            "hex": "7900",
            "id": "eQA",
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
            "creation_timestamp": "2021-04-21T13:24:00.103-07:00",
            "description": "",
            "id": "projects/alw-gke-103/regions/northamerica-northeast1/routers/private-cluster-router",
            "name": "private-cluster-router",
            "network": "https://www.googleapis.com/compute/v1/projects/alw-gke-103/global/networks/public-cluster-network",
            "project": "alw-gke-103",
            "region": "northamerica-northeast1",
            "self_link": "https://www.googleapis.com/compute/v1/projects/alw-gke-103/regions/northamerica-northeast1/routers/private-cluster-router",
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
            "id": "alw-gke-103/northamerica-northeast1/private-cluster-router/cloud-nat-ey2xh9",
            "log_config": [],
            "min_ports_per_vm": 64,
            "name": "cloud-nat-ey2xh9",
            "nat_ip_allocate_option": "AUTO_ONLY",
            "nat_ips": null,
            "project": "alw-gke-103",
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
            "id": "ey2xh9",
            "keepers": null,
            "length": 6,
            "lower": true,
            "min_lower": 0,
            "min_numeric": 0,
            "min_special": 0,
            "min_upper": 0,
            "number": true,
            "override_special": null,
            "result": "ey2xh9",
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
            "id": "alw-gke-103/binaryauthorization.googleapis.com",
            "project": "alw-gke-103",
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
            "id": "alw-gke-103/compute.googleapis.com",
            "project": "alw-gke-103",
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
            "id": "alw-gke-103/container.googleapis.com",
            "project": "alw-gke-103",
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
            "id": "alw-gke-103/containerregistry.googleapis.com",
            "project": "alw-gke-103",
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
            "id": "alw-gke-103/iam.googleapis.com",
            "project": "alw-gke-103",
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
            "id": "alw-gke-103/iap.googleapis.com",
            "project": "alw-gke-103",
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
            "id": "alw-gke-103/logging.googleapis.com",
            "project": "alw-gke-103",
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
            "id": "alw-gke-103/monitoring.googleapis.com",
            "project": "alw-gke-103",
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
            "id": "alw-gke-103/stackdriver.googleapis.com",
            "project": "alw-gke-103",
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
            "id": "alw-gke-103/cloudkms.googleapis.com",
            "project": "alw-gke-103",
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
            "access_token": "ya29.a0AfH6SMDbWChp0qLqQLNfwbRdS-B1SoqkVHBe36PIrbVFSiYg5HV3cy_dotgdN8EJIBTA_frOKWseFOAGacWOFD9o-mgAT-PK_mjUlrPD4YWEtP_EFjSg9_4XtaqaoFUiVkcVs1DfLVGJWXI6xyYZzqis-oJVkVc63Gjm7gGK_D0-9t-NUS84KUcPuw1WjbQlGltTcaaDFjw1X4qIlCfzcqPe8qL0KsYQrA9LZ7PtJVErprCKGw4MzE5IspZOs-vibBBkVw",
            "id": "projects/alw-gke-103/regions//zones/",
            "project": "alw-gke-103",
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
            "id": "projects/alw-gke-103/regions/northamerica-northeast1",
            "names": [
              "northamerica-northeast1-a",
              "northamerica-northeast1-b",
              "northamerica-northeast1-c"
            ],
            "project": "alw-gke-103",
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
            "id": "2021-04-21 20:24:03.055363229 +0000 UTC",
            "latest_master_version": "1.19.8-gke.1600",
            "latest_node_version": "1.19.8-gke.1600",
            "location": "northamerica-northeast1",
            "project": "alw-gke-103",
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
            "id": "2021-04-21 20:24:03.435266759 +0000 UTC",
            "latest_master_version": "1.19.8-gke.1600",
            "latest_node_version": "1.19.8-gke.1600",
            "location": "northamerica-northeast1-a",
            "project": "alw-gke-103",
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
                "key_name": "projects/alw-gke-103/locations/northamerica-northeast1/keyRings/public-endpoint-cluster-kr-7900/cryptoKeys/public-endpoint-cluster-kek",
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
            "endpoint": "35.203.21.143",
            "id": "projects/alw-gke-103/locations/northamerica-northeast1/clusters/public-endpoint-cluster",
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
                "cluster_ca_certificate": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURLekNDQWhPZ0F3SUJBZ0lSQUtMekw2cCtuejdOTGV3RDJhc0NQaVl3RFFZSktvWklodmNOQVFFTEJRQXcKTHpFdE1Dc0dBMVVFQXhNa1pqWmlNREJpT0RNdFptUmhPUzAwTjJJMExUZ3dNVGN0TTJNek0yUm1NRGt3WXpSaApNQjRYRFRJeE1EUXlNVEU1TWpReU1Wb1hEVEkyTURReU1ESXdNalF5TVZvd0x6RXRNQ3NHQTFVRUF4TWtaalppCk1EQmlPRE10Wm1SaE9TMDBOMkkwTFRnd01UY3RNMk16TTJSbU1Ea3dZelJoTUlJQklqQU5CZ2txaGtpRzl3MEIKQVFFRkFBT0NBUThBTUlJQkNnS0NBUUVBMFJtNTB1VWs0Rm1FaU9waEJxZ2c3dHBHR3VxSGNaSnhEYU9vWEVFTgo2QkkwQkIzKzRkVFFIVWdYd3N0N0hySVZmckFFdld5d0VLdFJ5aG40ZnNGRFQ3TWxCRTF0MkVuWTdhUm5GcnoyCmkxM0ljeDgrUG5CTnZPUHBvZG50V0ROVjlQM3dYaVhiS3pEWlR0T3FqWWI5ZktNY21xeEZ5d2FyMllRNVhBQWoKTTdGbFl2dmlrOXFNN244V1ZHRUJ4cytHYjdrY2g1eGluQWlZaks0M0QwN0lITWVrUGZ3bzdkWlZoY0hVZ2Z3TAo4cVZPZEd2R3Y5WHFPdmZYQ3RNZitzWFVrYjFDWmJxcjFPaTBrSFRRRzFwaTU4V2pMRUFBREdaZ1YyVEN2TTJECnQwWDdva09zY0ZBejZNOU80UVZWenM0aWZOTjhZTTJNMS9pK1AydWxSSWU3QndJREFRQUJvMEl3UURBT0JnTlYKSFE4QkFmOEVCQU1DQWdRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVVA3WkVTRXB6ZWRKNApWamdsMTBxOVpNVzBtQlV3RFFZSktvWklodmNOQVFFTEJRQURnZ0VCQUk0bFJFdE5OM1BSbkpEOUNQOEVOMlQ2CkpsYmY4d0Uwem1nTzc2MzhtMFcvWE42VFc1bmVwZEQ2UnUySHVVcGlScEY2YW51Q2RvSXZHU0VOeEdiS3BmaWgKdFdvZGdya3VDOWU3VVVIM3lVWklQNGM4bTdySEtmTlZHL0FhNXFMSFJDaUtoeFNnVnArTjYvNGQ0aEplNVcxbgp5eE1BYzJLOXVraHE4dGd2TnN6V0tWVFI0b0NVL1NBamdoT3Vtb0Q3K3NhSFAvVGFCQ2hlcm1NRGF1a2QxcmxPCngySVlmSWZUTkJRL0JYcWR0cGJsWkF1dDVWa2Z6TEdmVFpZa0RPYUhCTEo3dk5lc09TV2s0cUYvMS8xTkQwUjQKeEMwNytNdkNJNlFkZmpybDdRb3N6RmhQNDlKSG8rL0hGaUVwN2VkbW81WG5kd3puVnRjMEZNY2dadlpVMm5NPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",
                "password": "",
                "username": ""
              }
            ],
            "master_authorized_networks_config": [
              {
                "cidr_blocks": [
                  {
                    "cidr_block": "35.231.215.193/32",
                    "display_name": "Bastion Host"
                  }
                ]
              }
            ],
            "master_version": "1.18.16-gke.502",
            "min_master_version": null,
            "monitoring_service": "monitoring.googleapis.com/kubernetes",
            "name": "public-endpoint-cluster",
            "network": "projects/alw-gke-103/global/networks/public-cluster-network",
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
                "peering_name": "gke-nc8791c9f93984a4a1bc-7ecb-9c54-peer",
                "private_endpoint": "172.16.0.18",
                "public_endpoint": "35.203.21.143"
              }
            ],
            "project": "alw-gke-103",
            "release_channel": [
              {
                "channel": "REGULAR"
              }
            ],
            "remove_default_node_pool": true,
            "resource_labels": null,
            "resource_usage_export_config": [],
            "self_link": "https://container.googleapis.com/v1beta1/projects/alw-gke-103/locations/northamerica-northeast1/clusters/public-endpoint-cluster",
            "services_ipv4_cidr": "10.10.192.0/18",
            "subnetwork": "projects/alw-gke-103/regions/northamerica-northeast1/subnetworks/public-cluster-subnet",
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
                "identity_namespace": "alw-gke-103.svc.id.goog"
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
            "id": "projects/alw-gke-103/locations/northamerica-northeast1/clusters/public-endpoint-cluster/nodePools/public-node-pool",
            "initial_node_count": 3,
            "instance_group_urls": [
              "https://www.googleapis.com/compute/v1/projects/alw-gke-103/zones/northamerica-northeast1-a/instanceGroupManagers/gke-public-endpoint--public-node-pool-9eb35ef2-grp",
              "https://www.googleapis.com/compute/v1/projects/alw-gke-103/zones/northamerica-northeast1-b/instanceGroupManagers/gke-public-endpoint--public-node-pool-89bb6019-grp",
              "https://www.googleapis.com/compute/v1/projects/alw-gke-103/zones/northamerica-northeast1-c/instanceGroupManagers/gke-public-endpoint--public-node-pool-792bada5-grp"
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
                "service_account": "public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
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
            "project": "alw-gke-103",
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
              "northamerica-northeast1-c",
              "northamerica-northeast1-b"
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
            "id": "jhsd",
            "keepers": null,
            "length": 4,
            "lower": true,
            "min_lower": 0,
            "min_numeric": 0,
            "min_special": 0,
            "min_upper": 0,
            "number": true,
            "override_special": null,
            "result": "jhsd",
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
            "id": "272969757094302809",
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
            "id": "26a4d04e87650087a3d0cbd9467601052c11209afc2fa708b7e1ede315572055",
            "rendered": "{\n  \"type\": \"service_account\",\n  \"project_id\": \"alw-gke-103\",\n  \"private_key_id\": \"3defd78c320fb17d14364ce223242be64f774b32\",\n  \"private_key\": \"-----BEGIN PRIVATE KEY-----\\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDO6E0WAjcsetU5\\nLLIoT57iJ/WGsS9TMOa5Ig/M6wrqcASb+Sa12ebs4UkIOl9hcIJ43R1UelniIs26\\nIsiT4d5dFyTI+aFA+p5pjUBmFp37Y+V2k/hYn/WQKkIatDcUsw+NzVxgqrT5Sl//\\nnVh36wn31a5yINJQwFZjU6NyYhySEHimrFrZHW0eUECWs/Ozzv+zP0r5YCveGzEf\\n0obRA4A7cmbCAtAFLvAh3TP66jNZYEmPCGIQeVRlY1xXhImQnuE/mFVd1fyZAlOd\\nC2nqXKSSQC5JPRjOVMJrmaS3klrLfH4kvLADpnH5z4dM8WCQ2INHBTuHSTDDoXF5\\nJV+dSf+9AgMBAAECggEAGp9QP9s0HzCE2/Dw0XgBMQdEM7r7pGAf58VGtC6v/l9A\\ncJM71F0/tc38+CaOnDp+Ry/oNLTzeMHSp7cPCNwgoOi37nYUNgipNlqa5SfW1wBR\\nB5NdeoXGcnDFhasXhT3O7Ad28ec1FvhnZrvnpLJk23MumXe4p/Q/iVM7Lh4KoA5r\\n9gNyJlOVhJf6C7SFP7nWi2N7tdYhP5XlbHYY4T42G07Zxq8xmL5xLjgLgzWz1LBx\\nr3ePZu3RtiIfhtYHo2VvCdaOMYP3GR++naxC6gFzuGT1hjTET81UHjtGviTICmaN\\nxEgfn5p1itIo12j8QjlX+rw8awk1armZkuNcdjFwXwKBgQD/AaucGlxeweIttAJD\\nyrfOl7c62jE7R5ACvCV64OSU+OGdmQLKiiDAX5t7KwVfh8E0vVrZ5g1mKSXeQ96s\\nWDUhj/3FsHNFgLY4P7svdqHD+FUm95MHKyjjsDkgD5xknTtS5Gi5v094PDyOzwjX\\n/rbVJmqLDJB6Uk0DAb9w9iE5cwKBgQDPtqjKeHOOEyjKeXQbGYZ6jbma/PVwErD6\\nQKgSl2UFmHtpImnEfAp4S84nhcv+JGa9RGVjarMScIXgxjN5JSIS5BdVrL5GEQ+/\\nF3YwdLiApFdCizsXjiTIoQN/8/KtY91/BBl+cwdqg8PT/58LiDN+nRGKBZQZ+c6W\\nAk54MQlWDwKBgGd/Xw5JaKoQ2OKhx7WKBlX0H6rkOc0Me3eQs0mPE1cfODrFimt3\\n6lkJtMolqNWf/JuSKth7VX7cPoFaXHrohg/sKBxfRDm2Rr7HpwpZhMhL9wuMugDT\\n1JGsyVKo41m2swguqg6RhgiPsihoAPfhaoVSRTXQUKdE1frdb7zCOLPfAoGAMFFQ\\nMFEWqE0Cpx7biFZGtwlyzH/dZCWk74HM1w5KnKOcyZcMvX0RPmx71yvDiSnUkGBx\\nqU+vujFcoy3X2W1u4LAYUYCufkQHwq7lel4ccShJeBxFMbSKD/WMh94qbHUXmC1O\\n9OAzMG7YRd9nktorCF/nLZEgo249xR1iPYlCn7cCgYEAqa7CN3MCswu86z/EYpIl\\n5JmjcyIYFx42SwDypC9c8MvwW8d0Kct0NxR5ZA29xf0TMgf9dmX0o4M0q/bI84Qx\\nPybHJg8Bz6JqGHwm++XqgTNOzVaVfYnXSR8VyZ9zm9u4/4G1qK1gPgEUov+cSUNs\\nXPHX2rNf6H59Tcy+LkbyFtg=\\n-----END PRIVATE KEY-----\\n\",\n  \"client_email\": \"public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com\",\n  \"client_id\": \"108148418641691429456\",\n  \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\",\n  \"token_uri\": \"https://oauth2.googleapis.com/token\",\n  \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\",\n  \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/public-endpoint-cluster-sa%40alw-gke-103.iam.gserviceaccount.com\"\n}\n",
            "template": "${key}",
            "vars": {
              "key": "{\n  \"type\": \"service_account\",\n  \"project_id\": \"alw-gke-103\",\n  \"private_key_id\": \"3defd78c320fb17d14364ce223242be64f774b32\",\n  \"private_key\": \"-----BEGIN PRIVATE KEY-----\\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDO6E0WAjcsetU5\\nLLIoT57iJ/WGsS9TMOa5Ig/M6wrqcASb+Sa12ebs4UkIOl9hcIJ43R1UelniIs26\\nIsiT4d5dFyTI+aFA+p5pjUBmFp37Y+V2k/hYn/WQKkIatDcUsw+NzVxgqrT5Sl//\\nnVh36wn31a5yINJQwFZjU6NyYhySEHimrFrZHW0eUECWs/Ozzv+zP0r5YCveGzEf\\n0obRA4A7cmbCAtAFLvAh3TP66jNZYEmPCGIQeVRlY1xXhImQnuE/mFVd1fyZAlOd\\nC2nqXKSSQC5JPRjOVMJrmaS3klrLfH4kvLADpnH5z4dM8WCQ2INHBTuHSTDDoXF5\\nJV+dSf+9AgMBAAECggEAGp9QP9s0HzCE2/Dw0XgBMQdEM7r7pGAf58VGtC6v/l9A\\ncJM71F0/tc38+CaOnDp+Ry/oNLTzeMHSp7cPCNwgoOi37nYUNgipNlqa5SfW1wBR\\nB5NdeoXGcnDFhasXhT3O7Ad28ec1FvhnZrvnpLJk23MumXe4p/Q/iVM7Lh4KoA5r\\n9gNyJlOVhJf6C7SFP7nWi2N7tdYhP5XlbHYY4T42G07Zxq8xmL5xLjgLgzWz1LBx\\nr3ePZu3RtiIfhtYHo2VvCdaOMYP3GR++naxC6gFzuGT1hjTET81UHjtGviTICmaN\\nxEgfn5p1itIo12j8QjlX+rw8awk1armZkuNcdjFwXwKBgQD/AaucGlxeweIttAJD\\nyrfOl7c62jE7R5ACvCV64OSU+OGdmQLKiiDAX5t7KwVfh8E0vVrZ5g1mKSXeQ96s\\nWDUhj/3FsHNFgLY4P7svdqHD+FUm95MHKyjjsDkgD5xknTtS5Gi5v094PDyOzwjX\\n/rbVJmqLDJB6Uk0DAb9w9iE5cwKBgQDPtqjKeHOOEyjKeXQbGYZ6jbma/PVwErD6\\nQKgSl2UFmHtpImnEfAp4S84nhcv+JGa9RGVjarMScIXgxjN5JSIS5BdVrL5GEQ+/\\nF3YwdLiApFdCizsXjiTIoQN/8/KtY91/BBl+cwdqg8PT/58LiDN+nRGKBZQZ+c6W\\nAk54MQlWDwKBgGd/Xw5JaKoQ2OKhx7WKBlX0H6rkOc0Me3eQs0mPE1cfODrFimt3\\n6lkJtMolqNWf/JuSKth7VX7cPoFaXHrohg/sKBxfRDm2Rr7HpwpZhMhL9wuMugDT\\n1JGsyVKo41m2swguqg6RhgiPsihoAPfhaoVSRTXQUKdE1frdb7zCOLPfAoGAMFFQ\\nMFEWqE0Cpx7biFZGtwlyzH/dZCWk74HM1w5KnKOcyZcMvX0RPmx71yvDiSnUkGBx\\nqU+vujFcoy3X2W1u4LAYUYCufkQHwq7lel4ccShJeBxFMbSKD/WMh94qbHUXmC1O\\n9OAzMG7YRd9nktorCF/nLZEgo249xR1iPYlCn7cCgYEAqa7CN3MCswu86z/EYpIl\\n5JmjcyIYFx42SwDypC9c8MvwW8d0Kct0NxR5ZA29xf0TMgf9dmX0o4M0q/bI84Qx\\nPybHJg8Bz6JqGHwm++XqgTNOzVaVfYnXSR8VyZ9zm9u4/4G1qK1gPgEUov+cSUNs\\nXPHX2rNf6H59Tcy+LkbyFtg=\\n-----END PRIVATE KEY-----\\n\",\n  \"client_email\": \"public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com\",\n  \"client_id\": \"108148418641691429456\",\n  \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\",\n  \"token_uri\": \"https://oauth2.googleapis.com/token\",\n  \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\",\n  \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/public-endpoint-cluster-sa%40alw-gke-103.iam.gserviceaccount.com\"\n}\n"
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
          "index_key": "public-endpoint-cluster-sa-alw-gke-103=\u003eroles/artifactregistry.reader",
          "schema_version": 0,
          "attributes": {
            "condition": [],
            "etag": "BwXAgVddCGg=",
            "id": "alw-gke-103/roles/artifactregistry.reader/serviceaccount:public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "member": "serviceAccount:public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "project": "alw-gke-103",
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
          "index_key": "public-endpoint-cluster-sa-alw-gke-103=\u003eroles/logging.logWriter",
          "schema_version": 0,
          "attributes": {
            "condition": [],
            "etag": "BwXAgVddCGg=",
            "id": "alw-gke-103/roles/logging.logWriter/serviceaccount:public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "member": "serviceAccount:public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "project": "alw-gke-103",
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
          "index_key": "public-endpoint-cluster-sa-alw-gke-103=\u003eroles/monitoring.metricWriter",
          "schema_version": 0,
          "attributes": {
            "condition": [],
            "etag": "BwXAgVddCGg=",
            "id": "alw-gke-103/roles/monitoring.metricWriter/serviceaccount:public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "member": "serviceAccount:public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "project": "alw-gke-103",
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
          "index_key": "public-endpoint-cluster-sa-alw-gke-103=\u003eroles/monitoring.viewer",
          "schema_version": 0,
          "attributes": {
            "condition": [],
            "etag": "BwXAgVddCGg=",
            "id": "alw-gke-103/roles/monitoring.viewer/serviceaccount:public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "member": "serviceAccount:public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "project": "alw-gke-103",
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
          "index_key": "public-endpoint-cluster-sa-alw-gke-103=\u003eroles/stackdriver.resourceMetadata.writer",
          "schema_version": 0,
          "attributes": {
            "condition": [],
            "etag": "BwXAgVddCGg=",
            "id": "alw-gke-103/roles/stackdriver.resourceMetadata.writer/serviceaccount:public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "member": "serviceAccount:public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "project": "alw-gke-103",
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
          "index_key": "public-endpoint-cluster-sa-alw-gke-103=\u003eroles/storage.objectViewer",
          "schema_version": 0,
          "attributes": {
            "condition": [],
            "etag": "BwXAgVddCGg=",
            "id": "alw-gke-103/roles/storage.objectViewer/serviceaccount:public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "member": "serviceAccount:public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "project": "alw-gke-103",
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
            "email": "public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "id": "projects/alw-gke-103/serviceAccounts/public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "name": "projects/alw-gke-103/serviceAccounts/public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "project": "alw-gke-103",
            "timeouts": null,
            "unique_id": "108148418641691429456"
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
            "id": "projects/alw-gke-103/serviceAccounts/public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com/keys/3defd78c320fb17d14364ce223242be64f774b32",
            "keepers": null,
            "key_algorithm": "KEY_ALG_RSA_2048",
            "name": "projects/alw-gke-103/serviceAccounts/public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com/keys/3defd78c320fb17d14364ce223242be64f774b32",
            "private_key": "ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAiYWx3LWdrZS0xMDMiLAogICJwcml2YXRlX2tleV9pZCI6ICIzZGVmZDc4YzMyMGZiMTdkMTQzNjRjZTIyMzI0MmJlNjRmNzc0YjMyIiwKICAicHJpdmF0ZV9rZXkiOiAiLS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tXG5NSUlFdlFJQkFEQU5CZ2txaGtpRzl3MEJBUUVGQUFTQ0JLY3dnZ1NqQWdFQUFvSUJBUURPNkUwV0FqY3NldFU1XG5MTElvVDU3aUovV0dzUzlUTU9hNUlnL002d3JxY0FTYitTYTEyZWJzNFVrSU9sOWhjSUo0M1IxVWVsbmlJczI2XG5Jc2lUNGQ1ZEZ5VEkrYUZBK3A1cGpVQm1GcDM3WStWMmsvaFluL1dRS2tJYXREY1VzdytOelZ4Z3FyVDVTbC8vXG5uVmgzNnduMzFhNXlJTkpRd0ZaalU2TnlZaHlTRUhpbXJGclpIVzBlVUVDV3MvT3p6dit6UDByNVlDdmVHekVmXG4wb2JSQTRBN2NtYkNBdEFGTHZBaDNUUDY2ak5aWUVtUENHSVFlVlJsWTF4WGhJbVFudUUvbUZWZDFmeVpBbE9kXG5DMm5xWEtTU1FDNUpQUmpPVk1Kcm1hUzNrbHJMZkg0a3ZMQURwbkg1ejRkTThXQ1EySU5IQlR1SFNURERvWEY1XG5KVitkU2YrOUFnTUJBQUVDZ2dFQUdwOVFQOXMwSHpDRTIvRHcwWGdCTVFkRU03cjdwR0FmNThWR3RDNnYvbDlBXG5jSk03MUYwL3RjMzgrQ2FPbkRwK1J5L29OTFR6ZU1IU3A3Y1BDTndnb09pMzduWVVOZ2lwTmxxYTVTZlcxd0JSXG5CNU5kZW9YR2NuREZoYXNYaFQzTzdBZDI4ZWMxRnZoblpydm5wTEprMjNNdW1YZTRwL1EvaVZNN0xoNEtvQTVyXG45Z055SmxPVmhKZjZDN1NGUDduV2kyTjd0ZFloUDVYbGJIWVk0VDQyRzA3WnhxOHhtTDV4TGpnTGd6V3oxTEJ4XG5yM2VQWnUzUnRpSWZodFlIbzJWdkNkYU9NWVAzR1IrK25heEM2Z0Z6dUdUMWhqVEVUODFVSGp0R3ZpVElDbWFOXG54RWdmbjVwMWl0SW8xMmo4UWpsWCtydzhhd2sxYXJtWmt1TmNkakZ3WHdLQmdRRC9BYXVjR2x4ZXdlSXR0QUpEXG55cmZPbDdjNjJqRTdSNUFDdkNWNjRPU1UrT0dkbVFMS2lpREFYNXQ3S3dWZmg4RTB2VnJaNWcxbUtTWGVROTZzXG5XRFVoai8zRnNITkZnTFk0UDdzdmRxSEQrRlVtOTVNSEt5ampzRGtnRDV4a25UdFM1R2k1djA5NFBEeU96d2pYXG4vcmJWSm1xTERKQjZVazBEQWI5dzlpRTVjd0tCZ1FEUHRxaktlSE9PRXlqS2VYUWJHWVo2amJtYS9QVndFckQ2XG5RS2dTbDJVRm1IdHBJbW5FZkFwNFM4NG5oY3YrSkdhOVJHVmphck1TY0lYZ3hqTjVKU0lTNUJkVnJMNUdFUSsvXG5GM1l3ZExpQXBGZENpenNYamlUSW9RTi84L0t0WTkxL0JCbCtjd2RxZzhQVC81OExpRE4rblJHS0JaUVorYzZXXG5BazU0TVFsV0R3S0JnR2QvWHc1SmFLb1EyT0toeDdXS0JsWDBINnJrT2MwTWUzZVFzMG1QRTFjZk9EckZpbXQzXG42bGtKdE1vbHFOV2YvSnVTS3RoN1ZYN2NQb0ZhWEhyb2hnL3NLQnhmUkRtMlJyN0hwd3BaaE1oTDl3dU11Z0RUXG4xSkdzeVZLbzQxbTJzd2d1cWc2UmhnaVBzaWhvQVBmaGFvVlNSVFhRVUtkRTFmcmRiN3pDT0xQZkFvR0FNRkZRXG5NRkVXcUUwQ3B4N2JpRlpHdHdseXpIL2RaQ1drNzRITTF3NUtuS09jeVpjTXZYMFJQbXg3MXl2RGlTblVrR0J4XG5xVSt2dWpGY295M1gyVzF1NExBWVVZQ3Vma1FId3E3bGVsNGNjU2hKZUJ4Rk1iU0tEL1dNaDk0cWJIVVhtQzFPXG45T0F6TUc3WVJkOW5rdG9yQ0YvbkxaRWdvMjQ5eFIxaVBZbENuN2NDZ1lFQXFhN0NOM01Dc3d1ODZ6L0VZcElsXG41Sm1qY3lJWUZ4NDJTd0R5cEM5YzhNdndXOGQwS2N0ME54UjVaQTI5eGYwVE1nZjlkbVgwbzRNMHEvYkk4NFF4XG5QeWJISmc4Qno2SnFHSHdtKytYcWdUTk96VmFWZlluWFNSOFZ5Wjl6bTl1NC80RzFxSzFnUGdFVW92K2NTVU5zXG5YUEhYMnJOZjZINTlUY3krTGtieUZ0Zz1cbi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS1cbiIsCiAgImNsaWVudF9lbWFpbCI6ICJwdWJsaWMtZW5kcG9pbnQtY2x1c3Rlci1zYUBhbHctZ2tlLTEwMy5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsCiAgImNsaWVudF9pZCI6ICIxMDgxNDg0MTg2NDE2OTE0Mjk0NTYiLAogICJhdXRoX3VyaSI6ICJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vby9vYXV0aDIvYXV0aCIsCiAgInRva2VuX3VyaSI6ICJodHRwczovL29hdXRoMi5nb29nbGVhcGlzLmNvbS90b2tlbiIsCiAgImF1dGhfcHJvdmlkZXJfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9vYXV0aDIvdjEvY2VydHMiLAogICJjbGllbnRfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9yb2JvdC92MS9tZXRhZGF0YS94NTA5L3B1YmxpYy1lbmRwb2ludC1jbHVzdGVyLXNhJTQwYWx3LWdrZS0xMDMuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iCn0K",
            "private_key_type": "TYPE_GOOGLE_CREDENTIALS_FILE",
            "public_key": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvRENDQWVTZ0F3SUJBZ0lJU2U1SHNKVjA4bTh3RFFZSktvWklodmNOQVFFRkJRQXdJREVlTUJ3R0ExVUUKQXhNVk1UQTRNVFE0TkRFNE5qUXhOamt4TkRJNU5EVTJNQ0FYRFRJeE1EUXlNVEl3TWpNME9Wb1lEems1T1RreApNak14TWpNMU9UVTVXakFnTVI0d0hBWURWUVFERXhVeE1EZ3hORGcwTVRnMk5ERTJPVEUwTWprME5UWXdnZ0VpCk1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRRE82RTBXQWpjc2V0VTVMTElvVDU3aUovV0cKc1M5VE1PYTVJZy9NNndycWNBU2IrU2ExMmViczRVa0lPbDloY0lKNDNSMVVlbG5pSXMyNklzaVQ0ZDVkRnlUSQorYUZBK3A1cGpVQm1GcDM3WStWMmsvaFluL1dRS2tJYXREY1VzdytOelZ4Z3FyVDVTbC8vblZoMzZ3bjMxYTV5CklOSlF3RlpqVTZOeVloeVNFSGltckZyWkhXMGVVRUNXcy9Penp2K3pQMHI1WUN2ZUd6RWYwb2JSQTRBN2NtYkMKQXRBRkx2QWgzVFA2NmpOWllFbVBDR0lRZVZSbFkxeFhoSW1RbnVFL21GVmQxZnlaQWxPZEMybnFYS1NTUUM1SgpQUmpPVk1Kcm1hUzNrbHJMZkg0a3ZMQURwbkg1ejRkTThXQ1EySU5IQlR1SFNURERvWEY1SlYrZFNmKzlBZ01CCkFBR2pPREEyTUF3R0ExVWRFd0VCL3dRQ01BQXdEZ1lEVlIwUEFRSC9CQVFEQWdlQU1CWUdBMVVkSlFFQi93UU0KTUFvR0NDc0dBUVVGQndNQ01BMEdDU3FHU0liM0RRRUJCUVVBQTRJQkFRQWQ2U1EwRFBPNWljSEk2eFFkQjkrOAprSjIwbi8xL3FIU0pVVHhKMGF4aFIyRHN2VjhFcTh1RGRqM0cxWTM5czdsN3RiSFZMcW1EcTdzY1J2ZDB5VFhlCkZvRWhReEZJRHRyalRkTWgrUSs4MTlDeWR0VGM4MnF4YVpkVHhQVHk4MEltbzRUQUp1eVNqM2lLTHpaYzBKa1UKRzlEOFBzWjJjOTRHVy9CZ0x5azMwVENtZXFUY2JsVXF0OXV3TFB5WVVpZ0FvMy9pcTFRdkZsbWxyQUsxeVdiagpsQ0ZIVXBUVDM2L2VjeW9PcHlVckVUc2ZPZ3FvUWQ0TXBlMnVHMmVOdDUvMnJuaThUTHJad2RLZ0tyNUNneldRCmZvQzNmRlhDZytUcTc3QjNGd1V1MC92MnovdnJxOWN0NjNtbktmVVFvMzluUWF6K3Y0UkVnQjhGUW9JOTliSzUKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=",
            "public_key_data": null,
            "public_key_type": "TYPE_X509_PEM_FILE",
            "service_account_id": "public-endpoint-cluster-sa@alw-gke-103.iam.gserviceaccount.com",
            "valid_after": "2021-04-21T20:23:49Z",
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
            "creation_timestamp": "2021-04-21T13:24:00.362-07:00",
            "description": "This subnet is managed by Terraform",
            "fingerprint": null,
            "gateway_address": "10.10.10.1",
            "id": "projects/alw-gke-103/regions/northamerica-northeast1/subnetworks/public-cluster-subnet",
            "ip_cidr_range": "10.10.10.0/24",
            "log_config": [],
            "name": "public-cluster-subnet",
            "network": "https://www.googleapis.com/compute/v1/projects/alw-gke-103/global/networks/public-cluster-network",
            "private_ip_google_access": true,
            "private_ipv6_google_access": "DISABLE_GOOGLE_ACCESS",
            "project": "alw-gke-103",
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
            "self_link": "https://www.googleapis.com/compute/v1/projects/alw-gke-103/regions/northamerica-northeast1/subnetworks/public-cluster-subnet",
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
            "id": "projects/alw-gke-103/global/networks/public-cluster-network",
            "mtu": 0,
            "name": "public-cluster-network",
            "project": "alw-gke-103",
            "routing_mode": "GLOBAL",
            "self_link": "https://www.googleapis.com/compute/v1/projects/alw-gke-103/global/networks/public-cluster-network",
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
