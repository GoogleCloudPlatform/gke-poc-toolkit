export PROJECT=$(gcloud config get-value project)
export ZONE=$(gcloud config get-value compute/zone)
export GOVERNANCE_PROJECT=$(gcloud config get-value project)
export WINDOWS_CLUSTER=false
export PUBLIC_CLUSTER=false
export STATE=gcs
export CLUSTER_TYPE=private
export PREEMPTIBLE_NODES=false
