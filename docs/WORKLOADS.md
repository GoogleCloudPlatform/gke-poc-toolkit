# Deploying Secure Workloads to GKE

## Before you Start

## Kubernetes Config Connector (KCC)

## What Gets Deployed

A sample `storage-application` is deployed by KCC and leverages the following security best practices: 

#### Workload Identity

Workload identity is enabled on this cluster and is a way to securely provide access to Google cloud services within your Kubernetes cluster. To extend this, the sample `storage-application` leverages a kubernetes service account bound to a Google Cloud service account with permissions to a sample Google Cloud Storage (GCS) bucket.

After creation, a simple test is provided to demonstrate the sample application using this permission to access and write test data to the GCS bucket.  

## Deploying the Sample Workload

## Workload ID validation

Get the external IP of the test application and POST against the endpoint a few times. You should see a 200 when you are routed to the pod that is using a workload identity with the correct RBAC on the storage account and a 403 when routed to the pod that hath not RBAC.

```shell
SERVICE_EXT_IP=$(kubectl get service -n storage-application gcs-wi-test-lb -o yaml | grep ip: | awk 'END{ print $3}')
while true ; do curl -X POST -d 'Some test data' http://$SERVICE_EXT_IP/test; sleep 1 ; done
```