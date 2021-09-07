# GKE POC Toolkit - Command Line Interface 

This subdirectory contains code and sample config for the GKE POC Toolkit CLI. This Golang command-line tool wraps the Terraform scripts used to set up a GKE environment consisting of one or more clusters. 


## Configuration 

| Name                     | Type              | Valid Values                  | Default Value                                          |
|--------------------------|-------------------|-------------------------------|--------------------------------------------------------|
| `terraformState`         | string            | `local,cloud`                 | `local`                                                |
| `configSync`             | bool              |                               | (you are prompted for your GCP Project ID by the tool) |
| `clustersProjectId`      | string            |                               |                                                        |
| `prefix`                 | string            |                               | `""`                                                   |
| `governanceProjectId`    | string            |                               | (you are prompted for your GCP Project ID by the tool) |
| `vpcConfig.vpcName`      | string            | any non-empty string          | `"default"`                                            |
| `vpcConfig.vpcType`      | string            | `shared,standalone`           | `standalone`                                           |
| `vpcConfig.vpcProjectId` | string            |                               | (you are prompted for your GCP Project ID by the tool) |
| `clustersConfig`         | `[]ClusterConfig` | `ClusterConfig` values below! |                                                        |

### ClusterConfig


| Name                        | Type   | Valid Values                                                                               | Default Value                                         |
|-----------------------------|--------|--------------------------------------------------------------------------------------------|-------------------------------------------------------|
| `projectId`                 | string |                                                                                            | (you are prompted for your GCP Project ID on startup) |
| `nodeSize`                  | int    | 1-100                                                                                      | 3                                                     |
| `machineType`               | string | https://cloud.google.com/compute/docs/machine-types                                        | `e2-standard-4`                                       |
| `clusterType`               | string | `private,public`                                                                           | `public`                                              |
| `authIP`                    | string |                                                                                            |                                                       |
| `region`                    | string | https://cloud.google.com/compute/docs/regions-zones                                        |                                                       |
| `zone`                      | string | https://cloud.google.com/compute/docs/regions-zones                                        |                                                       |
| `subnetName`                | string | any non-empty string                                                                       | `"default"`                                           |
| `podCIDRName`               | string |                                                                                            |                                                       |
| `svcCIDRName`               | string |                                                                                            |                                                       |
| `enableWorkloadIdentity`    | bool   |                                                                                            |                                                       |
| `enableWindowsNodepool`     | bool   |                                                                                            |                                                       |
| `enablePreemptibleNodepool` | bool   |                                                                                            |                                                       |
| `defaultNodepoolOS`         | string | https://cloud.google.com/kubernetes-engine/docs/concepts/node-images#available_node_images | `cos`                                                 |
