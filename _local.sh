# Modify Argolis Policies that block GKE Toolkit deployment
# References: 
# - https://cloud.google.com/sdk/gcloud/reference/beta/resource-manager
# - https://cloud.google.com/compute/docs/images/restricting-image-access#trusted_images

# Outer loop - Loop through Argolis Projects
declare -a projects=("alw-sprj-04" 
                "alw-shared-vpc-04"
                )
for project in "${projects[@]}"
do

# Inner Loop - Loop Through Policies with Constraints
declare -a policies=("constraints/compute.trustedImageProjects" 
                "constraints/compute.vmExternalIpAccess"
                "constraints/compute.restrictSharedVpcSubnetworks"
                "constraints/compute.restrictSharedVpcHostProjects"
                "constraints/compute.restrictVpcPeering"
                )
for policy in "${policies[@]}"
do
cat <<EOF > new_policy.yaml
constraint: $policy
listPolicy:
 allValues: ALLOW
EOF
gcloud resource-manager org-policies set-policy new_policy.yaml --project=${project}
done
# End Inner Loop

# Disable Policies without Constraints
gcloud beta resource-manager org-policies disable-enforce compute.requireShieldedVm --project=${project}
gcloud beta resource-manager org-policies disable-enforce compute.requireOsLogin --project=${project}
gcloud beta resource-manager org-policies disable-enforce iam.disableServiceAccountKeyCreation --project=${project}
gcloud beta resource-manager org-policies disable-enforce iam.disableServiceAccountCreation --project=${project}

done
# End Outer Loop


###################
# Useful Commands #
###################

# Clone Repo
git clone https://github.com/albertwo1978/gke-poc-toolkit.git
cd gke-poc-toolkit/

# Git pull updates
git pull 

# Open Markdown preview in right pane
WIN+k v


##################
# Temp Commands  #
##################

export REGION=us-east1
export ZONE=us-east1-c
export PROJECT=alw-sprj-04
export GOVERNANCE_PROJECT=alw-sprj-05
export PUBLIC_CLUSTER=true
export SHARED_VPC=true
export CREATE_SHARED_VPC=true
export SHARED_VPC_PROJECT_ID=alw-shared-vpc-05
export SHARED_VPC_NAME=default
export SHARED_VPC_SUBNET_NAME=default
export POD_IP_RANGE_NAME=pod-ip-range
export SERVICE_IP_RANGE_NAME=service-ip-range

