# Deploying Secure Workloads to GKE

## Before you Start
This demo sets out to provide an example of how to deploy an entire application stack, including GCP PaaS resources, through the Kubernetes Resouce Model (KRM), without passing your application credentials to access the PaaS resources. To accmomplish this, we are using a combination of Workload Identity and Kubernetes Config Connector. 

### Kubernetes Config Connector (KCC):
KCC is a Kubernetes addon that allows you to manage Google Cloud resources through Kubernetes. It does so by providing a collection of Kubernetes Custom Resource Definitions (CRDs) and controllers. The Config Connector CRDs allow Kubernetes to create and manage Google Cloud resources when you configure and apply Objects to your cluster.

KCC was installed during the cluster creation and configured during the hardening install. If you would like to read up on the install steps, please check out the public docs [here](https://cloud.google.com/config-connector/docs/how-to/install-upgrade-uninstall).

### Workload Identity
Workload Identity allows you to bind a Kubernetes service account to a GCP service account allowing you to delegate GCP role based access controls to an app running in GKE.

Workload identity was enabled on this cluster during cluster creation. If you would like to read up on the install steps, please check out the public docs [here](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity).

## What Gets Deployed
All the resources need in this demo are installed with Kubernetes config found in the demos/workload-identity/ folder. Please check this folder AFTER running the demo start scripts as the scripts generate the manifests based on your envvars. Here is what gets deployed:
* A sample go application that leverages the GCP storage SDK. No special code needed to instantiate the connection to 
* Kubernetes services and an Ingress object that translates to an external Google Cloud Loadbalancer via the GCLB Ingress Controller.
* GCP service account (GSA), kubernetes service account (KSA) and an IAM Policy that binds them together.
* Google Cloud Storage bucket and a Policy that gives the apps workload Identity access to the bucket.

After creation, a simple test is provided to demonstrate the sample application using this permission to access and write test data to the GCS bucket.  

## Deploying the Sample Workload
In this demo, we will be generating some Kubernetes manifest files to deploy a demo app along with some GCP resources. Ensure you set the project envar that was previously used when creating GKE clusters:

```shell
# These should match the settings in the cluster build step
export PROJECT=<GCP Project>
```
Kick off the demo build like so:
```shell
# If running a public cluster simply run the following:

make start-wi-demo

# If running a private master endpoint, validate the proxy is started. Then set the HTTPS_PROXY environment variable to forward the make command through the tunnel:

make start-proxy

HTTPS_PROXY=localhost:8888 make start-wi-demo
```

If you are running this demo against a private master endpoint do yourself a solid create and alias to abstract away the proxy prefix like so:
```
alias kubectl="HTTPS_PROXY=localhost:8888 kubectl"
```

## Config Connector validation

Ensure that the GCLB has been configured by watching the ingress resource until the public IP appears. For example:
```shell
kubectl get ing -n workload-id-demo -w
NAME               CLASS    HOSTS                              ADDRESS          PORTS   AGE
workload-id-demo   <none>   good.example.com,bad.example.com   34.107.224.154   80      11h
```

Ensure that all the native Kubernetes resources have been deployed.
```shell
kubectl get all -n workload-id-demo
NAME                                   READY   STATUS    RESTARTS   AGE
pod/gcs-wi-test-74bfc944c9-7t69b       1/1     Running   0          10h
pod/gcs-wi-test-bad-68547f5d67-6gwdc   1/1     Running   0          10h

NAME                      TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/demo              ClusterIP      10.10.235.58    <none>        8080/TCP         12h
service/demo-bad          ClusterIP      10.10.206.167   <none>        8080/TCP         12h
service/gcs-wi-test-bad   LoadBalancer   10.10.235.80    34.74.19.50   8080:32353/TCP   12h

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/gcs-wi-test       1/1     1            1           10h
deployment.apps/gcs-wi-test-bad   1/1     1            1           10h
```

Ensure that all of the KCC resources have been deployed.
```shell
kubectl get IAMServiceAccount -n workload-id-demo
NAME                  AGE   READY   STATUS     STATUS AGE
workload-id-demo-sa   12h   True    UpToDate   12h

kubectl get IAMPolicy -n workload-id-demo
NAME                    AGE   READY   STATUS     STATUS AGE
workload-id-sa-policy   12h   True    UpToDate   12h

kubectl get StorageBucket -n workload-id-demo
NAME                            AGE   READY   STATUS     STATUS AGE
gke-application-bucket-24c78c   13h   True    UpToDate   111s

kubectl get IAMPolicyMember -n workload-id-demo
NAME                              AGE   READY   STATUS     STATUS AGE
workload-id-demo-storage-policy   12h   True    UpToDate   12h
```

## Workload ID validation
To validate that workload identity has been setup with our app we have deployed another app without the binding and will send a request at each an observe the response codes.

First we need to get the external IP of the GCLB. 

```shell
ING_EXT_IP=$(kubectl get ing -n workload-id-demo -o yaml | grep ip: | awk 'END{ print $3}')
```
Next create a test file to upload to the storage account via the app.
```shell
cat << EOF > test
Ureeka! it works!
EOF
```
Now we will curl the version of the app without the workload identity binding and observe the response code. You can see that this app does not have access to the bucket.
```shell
curl -H "host: bad.example.com" -F "file=@./test" $ING_EXT_IP/cloud-storage-bucket

{"error":true,"message":"googleapi: Error 403: Caller does not have storage.objects.create access to the Google Cloud Storage object., forbidden"}%
```
Now let's check the app with workload identity configured. 
```shell
curl -H "host: good.example.com" -F "file=@./test" $ING_EXT_IP/cloud-storage-bucket

{"message":"file uploaded successfully","pathname":"/gke-application-bucket-294935/test"}%
```
And validate that the file was loaded in the bucket.
```shell
BUCKET=$(gsutil list | grep gs://gke-application-bucket)
gsutil cat "${BUCKET}test"

Ureeka! it works!
```
## Cleaning up

There is a make command to delete the demo.
```shell
# For private endpoint clusters
HTTPS_PROXY=localhost:8888 make stop-wi-demo

# For public endpoint clusters
make stop-wi-demo
```
