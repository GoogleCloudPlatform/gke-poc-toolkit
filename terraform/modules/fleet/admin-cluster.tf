
module "gke" {
  deletion_protection                  = false
  source                               = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  authenticator_security_group         = var.authenticator_security_group
  enable_cost_allocation               = true
  enable_private_endpoint              = true
  gke_backup_agent_config              = true
  project_id                           = var.project_id
  fleet_project                        = var.fleet_project
  network                              = var.vpc_name
  ip_range_pods                        = "admin-pods"
  ip_range_services                    = "admin-svcs"
  identity_namespace                   = "${var.fleet_project}.svc.id.goog"
  release_channel                      = var.release_channel
  name                                 = "gke-ap-admin-cp-00"
  region                               = "us-central1"
  subnetwork                           = "admin-control-plane"
  network_project_id                   = var.vpc_project_id
  gateway_api_channel                  = "CHANNEL_STANDARD"
  grant_registry_access                = true
  dns_cache                            = true
  horizontal_pod_autoscaling           = true
  enable_private_nodes                 = true
  master_ipv4_cidr_block               = "172.16.100.16/28"
  depends_on = [ 
    module.vpc,
    google_project_service.services,
    ]
}