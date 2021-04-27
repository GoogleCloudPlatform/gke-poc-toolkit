# Deploying Secure Workloads to GKE

## Before you Start

## Kubernetes Config Connector (KCC)

## What Gets Deployed

A sample `storage-application` is deployed by KCC and leverages the following security best practices: 

#### Workload Identity

Workload identity is enabled on this cluster and is a way to securely provide access to Google cloud services within your Kubernetes cluster. To extend this, the sample `storage-application` leverages a kubernetes service account bound to a Google Cloud service account with permissions to a sample Google Cloud Storage (GCS) bucket.

After creation, a simple test is provided to demonstrate the sample application using this permission to access and write test data to the GCS bucket.  

## Deploying the Sample Workload

```shell
# If running a public cluster simply run the following:
make start-wi-demo

# If running a private master endpoint, validate the proxy is started. Then set the 
# HTTPS_PROXY environment variable to forward the make command through the tunnel:
make start-proxy

HTTPS_PROXY=localhost:8888 make start-wi-demo
```

# If you are running this demo against a private master endpoint do yourself a solid create and alias to abstract away the proxy prefix like so:
```
alias kubectl="HTTPS_PROXY=localhost:8888 kubectl"
```

## Workload ID validation

Get the external IP of the test application and POST against the endpoint a few times. You should see a 200 when you are routed to the pod that is using a workload identity with the correct RBAC on the storage account and a 403 when routed to the pod that hath not RBAC.

```shell
ING_EXT_IP=$(kubectl get ing -n workload-id-demo -o yaml | grep ip: | awk 'END{ print $3}')

cat << EOF > test
This is the end
this is the end
my friend
EOF

curl -H "host: bad.example.com" -F "file=@./test" $ING_EXT_IP/cloud-storage-bucket

curl -H "host: good.example.com" -F "file=@./test" $ING_EXT_IP/cloud-storage-bucket


```