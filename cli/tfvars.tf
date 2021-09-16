## Base Config
prefix                            = "mc"
region                            = "us-east1"
project_id                        = "gke-poc-toolkit-001"
governance_project_id             = "gke-poc-toolkit-001"
config_sync                       = "true"
private_endpoint                  = "true"
auth_ip                           = "<no value>"
windows_nodepool                  = "false"
preemptible_nodes                 = "false"

## VPC Config
shared_vpc                        = "false"
shared_vpc_name                   = "default"
shared_vpc_project_id             = "gke-poc-toolkit-001"
shared_vpc_ip_range_pods_name     = "podCidr"
shared_vpc_ip_range_services_name = "svcCidr"


## Clusters Config
cluster_config                    = {
	gke-central = {
	    region                    = "us-central1"
	    subnet_name               = "us-central1"
		#Zone                      = "<no value>"
		#NodeCount                 = "<no value>"
		#MachineType               = "<no value>"    
	}
	gke-east = {
	    region                    = "us-east1"
	    subnet_name               = "us-east1"
		#Zone                      = "<no value>"
		#NodeCount                 = "<no value>"
		#MachineType               = "<no value>"    
	}
}
