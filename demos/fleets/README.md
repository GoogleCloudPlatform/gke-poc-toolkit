# 🚲 GKE Poc Toolkit Demo: GKE Fleet setup with ConfigSync and Argo Rollouts
This demo shows you how to bootstrap a Fleet of GKE clusters using Config Sync as your gitops engine and Argo Rollouts to progressively release app updates.
Services in play:
* [ConfigSync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview)
* [Argo Rollouts](https://argoproj.github.io/argo-rollouts/)
* [GKE](https://cloud.google.com/kubernetes-engine/docs)
* [Multi Cluster Services](https://cloud.google.com/kubernetes-engine/docs/concepts/multi-cluster-services)
* [Multi Cluster Ingress](https://cloud.google.com/kubernetes-engine/docs/concepts/multi-cluster-ingress)
* [Anthos Service Mesh w/ Managed Control Plane](https://cloud.google.com/service-mesh/docs/overview#managed_anthos_service_mesh)



![diagram](assets/diagram.png)

## Fleet Infra setup

1. **Initiliaze the GKE POC Toolkit (gkekitctl init).** 
```bash
export GKE_PROJECT_ID=<your-project-id>
export OS="darwin" # choice of darwin or amd64
```

```bash
gcloud config set project $GKE_PROJECT_ID
gcloud auth login
gcloud auth application-default login

ROOT_DIR=`pwd`
mkdir gke-poc-toolkit && cd "$_"
VERSION=$(curl -s https://api.github.com/repos/GoogleCloudPlatform/gke-poc-toolkit/releases/latest | grep browser_download_url | cut -d "/" -f 8 | tail -1)
curl -sLSf -o ./gkekitctl https://github.com/GoogleCloudPlatform/gke-poc-toolkit/releases/download/${VERSION}/gkekitctl-${OS} && chmod +x ./gkekitctl

./gkekitctl init
```

2. **Configure the default Config Sync repo.**
```bash
ROOT_DIR=`pwd`
# Set up self signed cert for ASM Ingress Gateway
mkdir tmp
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
-subj "/CN=frontend.endpoints.${GKE_PROJECT_ID}.cloud.goog/O=Edge2Mesh Inc" \
-keyout tmp/frontend.endpoints.${GKE_PROJECT_ID}.cloud.goog.key \
-out tmp/frontend.endpoints.${GKE_PROJECT_ID}.cloud.goog.crt

gcloud secrets create edge2mesh-credential.crt --replication-policy="automatic" --data-file="tmp/frontend.endpoints.${GKE_PROJECT_ID}.cloud.goog.crt"
gcloud secrets create edge2mesh-credential.key --replication-policy="automatic" --data-file="tmp/frontend.endpoints.${GKE_PROJECT_ID}.cloud.goog.key"

rm -rf tmp

# Set Fleet project in the gkekitctl config
cd ${ROOT_DIR}/default-configs
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' -e "s/clustersProjectId: \"my-project\"/clustersProjectId: \"${GKE_PROJECT_ID}\"/g" config.yaml
  sed -i '' -e "s/fleetProjectId: \"my-project\"/fleetProjectId: \"${GKE_PROJECT_ID}\"/g" config.yaml
  sed -i '' -e "s/vpcProjectId: \"my-project\"/vpcProjectId: \"${GKE_PROJECT_ID}\"/g" config.yaml
else
  sed -i -e "s/clustersProjectId: \"my-project\"/clustersProjectId: \"${GKE_PROJECT_ID}\"/g" config.yaml
  sed -i -e "s/fleetProjectId: \"my-project\"/fleetProjectId: \"${GKE_PROJECT_ID}\"/g" config.yaml
  sed -i -e "s/vpcProjectId: \"my-project\"/vpcProjectId: \"${GKE_PROJECT_ID}\"/g" config.yaml
fi
```

3. **Export vars and add them to your GKE POC toolkit config.yaml.**
``` bash
cp ${ROOT_DIR}/config.yaml ${ROOT_DIR}/gke-poc-toolkit
cd ${ROOT_DIR}/gke-poc-toolkit 
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' -e "s/clustersProjectId: \"my-project\"/clustersProjectId: \"${GKE_PROJECT_ID}\"/g" config.yaml
  sed -i '' -e "s/fleetProjectId: \"my-project\"/fleetProjectId: \"${GKE_PROJECT_ID}\"/g" config.yaml
  sed -i '' -e "s/vpcProjectId: \"my-project\"/vpcProjectId: \"${GKE_PROJECT_ID}\"/g" config.yaml
else
  sed -i -e "s/clustersProjectId: \"my-project\"/clustersProjectId: \"${GKE_PROJECT_ID}\"/g" config.yaml
  sed -i -e "s/fleetProjectId: \"my-project\"/fleetProjectId: \"${GKE_PROJECT_ID}\"/g" config.yaml
  sed -i -e "s/vpcProjectId: \"my-project\"/vpcProjectId: \"${GKE_PROJECT_ID}\"/g" config.yaml
fi
```

4. **Run the gkekitctl create command from this directory.** This will take about 15 minutes to run.
```bash
./gkekitctl apply --config config.yaml
```

5. **Connect to your newly-created GKE clusters**

```bash
gcloud container clusters get-credentials mccp-central-01 --region us-central1 --project ${GKE_PROJECT_ID}
```

6. **We highly recommend installing [kubectx and kubens](https://github.com/ahmetb/kubectx) to switch kubectl contexts between clusters with ease. Once done, you can validate you clusters like so.**
```bash
kubectx mccp-central-01=gke_${GKE_PROJECT_ID}_us-central1_mccp-central-01
kubectl get nodes
```

*Expected output for each cluster*: 
```bash
NAME                                                  STATUS   ROLES    AGE   VERSION
gke-mccp-central-01-linux-gke-toolkit-poo-12b0fa78-grhw   Ready    <none>   11m   v1.21.6-gke.1500
gke-mccp-central-01-linux-gke-toolkit-poo-24d712a2-jm5g   Ready    <none>   11m   v1.21.6-gke.1500
gke-mccp-central-01-linux-gke-toolkit-poo-6fb11d07-h6xb   Ready    <none>   11m   v1.21.6-gke.1500
```
7. **Now we are going to delete the app clusters you created for a better demo flow.**
```bash
## Ensure the mccp cluster is the ingress config controller
gcloud container fleet ingress update --config-membership=mccp-central-01-membership -q

## Unregister the app clusters from the Fleet
gcloud container fleet memberships delete gke-std-west01-membership --project ${GKE_PROJECT_ID} -q
gcloud container fleet memberships delete gke-std-east01-membership --project ${GKE_PROJECT_ID} -q

## Delete the app clusters
gcloud container clusters delete gke-std-west01 --region us-west1 --project ${GKE_PROJECT_ID} -q --async
gcloud container clusters delete gke-std-east01 --region us-east1 --project ${GKE_PROJECT_ID} -q --async
```
## Fleet Cluster setup
So far we have the infrastructure laid out and now need to set up the multi cluster controller cluster with argocd, GKE Fleet components, and some other tooling needed for the demo. 

1. **Hydrate those configs with our project specific variable by running the Fleet prep script**
```bash
# Run the Fleet Prep script
cd ${ROOT_DIR}
./scripts/fleet_prep.sh -p ${GKE_PROJECT_ID}
```

## Promoting Application Clusters to the Fleet
Now that we have the multi cluster controller cluster setup, we need to create and promote a GKE cluster to the Fleet that will run applications. Since the multi cluster networking configs have been hydrating, adding a cluster with the environment=prod label in the ConfiSync cluster obect will ensure the new cluster syncs all the baseline tooling it needs, including ASM Gateways. We have also labeled this first cluster as a wave one cluster. The wave will be leveraged once apps start getting added.

1. **Run the application cluster add script**
```bash
./scripts/fleet_cluster_add.sh -p ${GKE_PROJECT_ID} -n gke-ap-west01 -l us-west1 -c "172.16.10.0/28" -t "autopilot" -w one
```

2. **Browse to the ConfigSync UI and you will see that the configs in subfolders in the app-clusters-config folder are installing. This state is all driven by the app clusters tooling application set which targets clusters labeled as prod.**

## Creating a new app from the app template
One application cluster is ready to serve apps. Now all we need to do is create configs for a new app and push them up to the ConfigSync sync repo and all the prep we have done will simply allow this app to start serving traffic through the ASM gateway.

1. **Run the team_app_add script**
```bash
./scripts/team_app_add.sh -a whereami -i "gcr.io/google-samples/whereami:v1.2.6" -p ${GKE_PROJECT_ID} -t team-2 -h "whereami.endpoints.${GKE_PROJECT_ID}.cloud.goog"
```

2. **Take a peek at the GKE workloads UI, filter by the whereami app namespaces for easier location of applications, and you will see that the whereami app is starting to rollout to all application servers labeled as wave-one (there is only one at this point).**

3. **Once the whereami pods have started navigate to it's endpoint and you will see that you are routed to a pod living in the us-west region. You can also curl the endpoint to the same effect.**
```bash
curl https://whereami.endpoints.${GKE_PROJECT_ID}.cloud.goog/
# The output should look something like this...
{
  "cluster_name": "gke-std-west02", 
  "host_header": "whereami.endpoints.argo-spike.cloud.goog", 
  "pod_name": "whereami-rollout-6d6cb979b5-5xzpj", 
  "pod_name_emoji": "🇨🇵", 
  "project_id": "argo-spike", 
  "timestamp": "2022-08-01T16:16:56", 
  "zone": "us-west1-b"
}
```

## Add another application cluster to the Fleet
Let's get another application cluster added to the Fleet. This time we will deploy the cluster to us-east and label it as a wave two cluster.

1. **Run the application cluster add script**
```bash
./scripts/fleet_cluster_add.sh -p ${GKE_PROJECT_ID} -n gke-ap-east01 -l us-east1-b -c "172.16.11.0/28" -t "autopilot" -w two
```

2. **Once the whereami pods have started on the us-east cluster, refresh the endpoint webpage or curl it again and you will see that you are routed to a pod living in the region that is closest to you. If you are closer to the west coast and want to see the east coast pod in action you can deploy a GCE instance in the east coast and curl from there or feel free to spin up a curl container in the us-east cluster and curl the endpoint from there.**
```bash
curl https://whereami.endpoints.${GKE_PROJECT_ID}.cloud.goog/
# The output should look something like this...
{
  "cluster_name": "gke-std-east01",
  "host_header": "whereami.endpoints.argo-spike.cloud.goog",
  "pod_name": "whereami-rollout-6d6cb979b5-x9h4v",
  "pod_name_emoji": "🧍🏽",
  "project_id": "argo-spike",
  "timestamp": "2022-08-01T16:23:42",
  "zone": "us-east1-b"
}
```

## Rolling out new version of an app
So far we have added an application cluster to the Fleet and new apps to those clusters. We've not shown off the usage of the wave label just yet, so we will do that now. First we need to create a new app that does a better job showing off Argo rollouts. Then we will progressively release the app to wave one followed by wave two clusters with a manual gate in between. 

1. **Run the team_app_add script**
```bash
./scripts/team_app_add.sh -a rollout-demo -i "argoproj/rollouts-demo:green" -p ${GKE_PROJECT_ID} -t team-1 -h "rollout-demo.endpoints.${GKE_PROJECT_ID}.cloud.goog"
```

2. **Release a new image of your app to wave one clusters**
```bash
./scripts/team_app_rollout.sh -a rollout-demo -t team-1 -i "argoproj/rollouts-demo" -l "yellow" -w "one"
```

3. **Check the state of your rollout in the argocd UI. You should see a new replicaset and pods being deployed with the new image tag and a progression through the steps of the rollout that generates an analysis templates result after each step. If the analysis does not pass, the rollout will stop and all traffic will be sent to the previous version.**


4. **Now that we have progressively release our new image to the first wave of clusters successfully we can move on to releasing the new image to wave two clusters.**
```bash
./scripts/team_app_rollout.sh -a rollout-demo -t team-1 -i "argoproj/rollouts-demo" -l "yellow" -w "two"
```

5. **All of the waves have been rolled out successfully and we need to merge the new image into main to conclude the rollout**
```bash
./scripts/team_app_rollout.sh -a rollout-demo -t team-1 -i "argoproj/rollouts-demo" -l "yellow" -w "done"
```


