# Analytics

The GKE PoC Toolkit collects usage data on an **opt-in** basis. You can opt-in to data collection when running `gkekitctl init` during setup: 

```bash
➜  gke-poc-toolkit ./gkekitctl init
INFO[0000] ☸️ ----- GKE POC TOOLKIT ----- 🛠
INFO[0000] 🔄 Initializing flat files for gkekitctl...
INFO[0000] 📊 Send anonymous analytics to GKE PoC Toolkit maintainers?
Use the arrow keys to navigate: ↓ ↑ → ←
? Select[Yes/No]:
  ▸ Yes
    No
```

If you opt in, the following data is collected every time you run `gkekitctl create`: (Included here with example values)

```JSON
{
    "create_id": "12345", 
    "cluster_id": "12345", 
    "version": "v1",   
    "gitCommit": "xyz",
    "timestamp": "2021-11-12T11:45:26.371Z",
    "os": "darwin_x64",
    "terraformState": "local",
    "region": "us-central1",
    "enableWorkloadIdentity": false, 
    "enablePreemptibleNodepool": false, 
    "defaultNodepoolOS": "cos",
    "privateEndpoint": false, 
    "enableConfigSync": true, 
    "enablePolicyController": true, 
    "anthosServiceMesh": true,
    "multiClusterGateway": false,
    "vpcType": "standalone", 
    "clusterIndex": 0, 
    "clusterNumNodes": 3, 
    "clusterType": "public", 
    "clusterMachineType": "e2-standard-4", 
    "clusterRegion": "us-central1", 
    "clusterZone": "us-central1-b"
}
```

One of these objects is sent for every cluster you create with the Toolkit. Note that no PII is collected. We do not collect your GCP project ID, your GCP account info, or your organization info. **`create_id`** and **`cluster_id`** are both randomly-generated UUIDs that allows us to group together clusters from a single `gkekitctl create` run, thus tracking how many clusters, on average, users want to create per environment. 

### links to code 
- [Analytics server](/analytics/server.go) 
- [Analytics client](/cli/pkg/analytics/client.go)
