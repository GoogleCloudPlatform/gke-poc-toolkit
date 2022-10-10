# GKE PoC Toolkit

![release](https://img.shields.io/github/v/release/googlecloudplatform/gke-poc-toolkit) ![stars](https://img.shields.io/github/stars/GoogleCloudPlatform/gke-poc-toolkit) ![license](https://img.shields.io/github/license/GoogleCloudPlatform/gke-poc-toolkit)


![logo](assets/logo-256.png)

The GKE Proof of Concept (PoC) Toolkit is a demo generator for [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine). 

![demo-gif](assets/demo.gif)
  
## Quickstart 

1. **[Create a Google Cloud Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects)** and connect it to an existing Billing account.
2. **Open a bash-compatible shell** (eg. [Google Cloud Shell](https://cloud.google.com/shell)) and ensure you have the following tools installed: 

* [Google Cloud SDK version >= 325.0.0](https://cloud.google.com/sdk/docs/downloads-versioned-archives)
* * [Terraform >= 0.13](https://www.terraform.io/downloads.html)
* [kubectl](https://kubernetes.io/docs/tasks/tools/) ( >= v1.20)

3. **Set your Project ID environment variable and operating system.** 

```bash
export PROJECT_ID=<your-project-id>
export OS="darwin" # choice of darwin or amd64 
```

4. **Set up local authentication to your project.**

```
gcloud config set project $PROJECT_ID
gcloud auth login
gcloud auth application-default login
```

5. **Download the GKE PoC Toolkit binary.** 

```shell
mkdir gke-poc-toolkit && cd "$_"
VERSION=$(curl -s https://api.github.com/repos/GoogleCloudPlatform/gke-poc-toolkit/releases/latest | grep browser_download_url | cut -d "/" -f 8 | tail -1)
curl -sLSf -o ./gkekitctl https://github.com/GoogleCloudPlatform/gke-poc-toolkit/releases/download/${VERSION}/gkekitctl-${OS} && chmod +x ./gkekitctl
```

6. **Initialize the cli:**
```bash 
./gkekitctl init
```

7. **Run `gkekitctl create` to run the Toolkit.** By default, this command sets up a single-cluster GKE environment. ([Configuration here](cli/pkg/cli_init/samples/default-config.yaml)). Enter your project ID when prompted.

```shell
./gkekitctl create
```
```shell
# expected output 
INFO[0000] ☸️ ----- GKE POC TOOLKIT ----- 🛠
INFO[0000] Enter your Google Cloud Project ID:
```

This command takes about **10 minutes** to run; when it completes, you will have a full GKE demo environment ready to explore and deploy applications to. 

```bash
# Expected output on successful run 
Apply complete! Resources: 61 added, 0 changed, 0 destroyed.
time="2022-02-04T21:57:59Z" level=info msg="🔄 Finishing ACM install..."
time="2022-02-04T21:57:59Z" level=info msg="☸️ Generating Kubeconfig..."
time="2022-02-04T21:57:59Z" level=info msg="Clusters Project ID is gpt-e2etest-020422-214428"
time="2022-02-04T21:58:00Z" level=info msg="Connecting to cluster: gke_gpt-e2etest-020422-214428_us-central1_gke-central,"
time="2022-02-04T21:58:00Z" level=info msg="✔️ Kubeconfig generated: &{Kind:Config APIVersion:v1 Preferences:{Colors:false Extensions:map[]} Clusters:map[gke_gpt-e2etest-020422-214428_us-central1_gke-central:0xc000844900] AuthInfos:map[gke_gpt-e2etest-020422-214428_us-central1_gke-central:0xc0008a23c0] Contexts:map[gke_gpt-e2etest-020422-214428_us-central1_gke-central:0xc0012bad20] CurrentContext: Extensions:map[]}"
time="2022-02-04T21:58:00Z" level=info msg="☸️  Verifying Kubernetes API access for all clusters..."
time="2022-02-04T21:58:00Z" level=info msg="🌎 5 Namespaces found in cluster=gke_gpt-e2etest-020422-214428_us-central1_gke-central"
```

## Update

If you want to update your environment change the config file and run the update command. This is a great way to add or remove clusters.
```bash
./gkekitctl update --config <config file name>
```

## Clean up 

```bash
./gkekitctl delete
```

## Learn More

- [🤔 FAQ](/docs/frequently-asked-questions.md)  
- [✏️ Configuration](/docs/configuration.md): how to customize your Toolkit environment 
- [📦 Building Demos with the Toolkit](/docs/building-demos.md) 
- [🗺 Architecture](/docs/architecture.md)
- [📊 Analytics](/docs/analytics.md)
