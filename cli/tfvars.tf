project_id                        = "gke-toolkit-test-326113"
governance_project_id             = "gke-toolkit-test-326113"
region                            = "us-central1"
private_endpoint                  = "true"
auth_ip                           = ""
windows_nodepool                  = "false"
preemptible_nodes                 = "false"
shared_vpc                        = "false"
shared_vpc_name                   = "default"
shared_vpc_project_id             = "gke-toolkit-test-326113"
shared_vpc_ip_range_pods_name     = ""
shared_vpc_ip_range_services_name = ""
cluster_config					  = {
    cluster-01 = {
        region           = "us-central1"
        subnet_name      = "default"
    }
}