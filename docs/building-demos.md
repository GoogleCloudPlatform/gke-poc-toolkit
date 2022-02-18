# Building Demos with the Toolkit 

The GKE PoC Toolkit is designed to provide a reusable base-layer for different GKE demos. A toolkit environment gets you as far as as project with GKE clusters and add-ons installed, including Anthos Service Mesh and Anthos Config Management. 

Beyond this base layer, you can deploy sample applications and install additional tools. 


## Getting `kubectl` access to your clusters

To authenticate to all the clusters created with a single run of `gkekictl create`, you'll need a [kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/). `gkekitctl create` generates this file on every run and saves it as `[YOUR-TOOLKIT_DIR]/kubeconfig`. 

So once `gkekitctl create` completes, set your KUBECONFIG env variable like this: 

```bash
export KUBECONFIG=[PATH/TO/gke-poc-toolkit]/kubeconfig
```

From here, you can use the [`kubectx`](https://github.com/ahmetb/kubectx) tool to easily switch back and forth between your Toolkit clusters and run commands like `kubectl get pods`. 

## Deploying workloads 

Let's say you want to deploy a sample application like [Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo) to your Toolkit environment. Or you want to install an addional platform layer like [Kubeflow](https://www.kubeflow.org/docs/distributions/gke/).

First, get the YAML you want to deploy (eg. [release manifests](https://github.com/GoogleCloudPlatform/microservices-demo/blob/main/release/kubernetes-manifests.yaml)), and save it locally. 

From here, the most straightforward way to deploy Kubernetes workloads and configuration to your toolkit clusters is via Config Sync (Anthos Config Management). To do this, clone your toolkit Config Sync repo, add some YAML, and push to the `main` branch. 

By default, these configs will be deployed to all your toolkit clusters; you can also [use cluster selectors](https://cloud.google.com/anthos-config-management/docs/how-to/clusterselectors) to choose which configs land where. 

You can also set up CI/CD using Cloud Build or Cloud Deploy to GKE - this is ideal for demos targeting app developers.  
