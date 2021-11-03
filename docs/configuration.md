# GKE POC Toolkit - Command Line Interface 

This subdirectory contains code and sample config for the GKE POC Toolkit CLI. This Golang command-line tool wraps the Terraform scripts used to set up a GKE environment consisting of one or more clusters. 


## Configuration 

| Name                        | Type              | Valid Values                                                                               | Default Value                                          |
| --------------------------- | ----------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------ |
| `region`                    | string            | any Google Cloud region                                                                    | `us-central1`                                          |
| `terraformState`            | string            | `local,cloud`                                                                              | `local`                                                |
| `configSync`                | bool              | https://cloud.google.com/anthos-config-management/docs/config-sync-overview                                                                                           | `false`                                                       |
| `clustersProjectId`         | string            |                                                                                            | (you are prompted for your GCP Project ID by the tool) |
| `governanceProjectId`       | string            |                                                                                            | (you are prompted for your GCP Project ID by the tool) |
| `privateEndpoint`           | string            | https://cloud.google.com/kubernetes-engine/docs/concepts/private-cluster-concept#endpoints_in_private_clusters                                                                                           | `false`                                                  |
| `enableWorkloadIdentity`    | bool              | https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity                                                                                           | `true`                                                       |
| `enableWindowsNodepool`     | bool              | https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster-windows                                                                                           |  `false`                                                   |
| `enablePreemptibleNodepool` | bool              | https://cloud.google.com/compute/docs/instances/preemptible                                                                                            |  `false`                                                      |
| `defaultNodepoolOS`         | string            | https://cloud.google.com/kubernetes-engine/docs/concepts/node-images#available_node_images | `cos`                                                  |
| `vpcConfig`         | VpcConfig            | `VocConfig` values below                                                                       |                                            |
| `clustersConfig`            | `[]ClusterConfig` | `ClusterConfig` values below!                                                              |                                                        |

### VpcConfig


| Name                        | Type              | Valid Values                                                                               | Default Value                                          |
| --------------------------- | ----------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------ |
| `vpcConfig.vpcName`         | string            | any non-empty string                                                                       | `"default"`                                            |
| `vpcConfig.vpcType`         | string            | `shared,standalone`                                                                        | `standalone`                                           |
| `vpcProjectId`       | string            |                                                                                            | (you are prompted for your GCP Project ID by the tool) || `podCIDRName` | string |                                                     |                                                       |
| `svcCIDRName` | string |                                                     |                                                       |
| `podCIDRName` | string |                                                     |                                                       |
| `authIP` | string | https://cloud.google.com/compute/docs/machine-types |  
|                                                       |

### ClusterConfig


| Name          | Type   | Valid Values                                        | Default Value                                         |
| ------------- | ------ | --------------------------------------------------- | ----------------------------------------------------- |
| `projectId`   | string |                                                     | (you are prompted for your GCP Project ID on startup) |
| `nodeSize`    | int    | 1-100                                               | 3                                                     |
| `machineType` | string | https://cloud.google.com/compute/docs/machine-types | `e2-standard-4`                                       |
| `clusterType` | string | `private,public`                                    | `public`                                              |
|  `region`      | string | https://cloud.google.com/compute/docs/regions-zones |                                                       |
| `zone`        | string | https://cloud.google.com/compute/docs/regions-zones |                                                       |
| `subnetName`  | string | any non-empty string                                | `"default"`                                           |
|                                                       |
