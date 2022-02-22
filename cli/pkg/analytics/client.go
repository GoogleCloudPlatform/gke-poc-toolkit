/*
Copyright © 2020 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package analytics

import (
	"bytes"
	"encoding/json"
	"gkekitctl/pkg/config"

	"net/http"
	"runtime"
	"time"

	"github.com/gofrs/uuid"
	log "github.com/sirupsen/logrus"
)

// SendMetrics runs on gkekitctl create, after config validation and before TF apply. It gets the user's OS, scrubs their project ID data, and sends their create configuration to the metrics server.

// This is an Analytics-only object representing 1 GKE cluster created with gkekitctl.
type Cluster struct {
	ClusterId                 string `json:"clusterId"`
	CreateId                  string `json:"createId"`
	Version                   string `json:"version"`
	GitCommit                 string `json:"gitCommit"`
	Timestamp                 string `json:"timestamp"`
	OS                        string `json:"os"`
	TerraformState            string `json:"terraformState"`
	Region                    string `json:"region"`
	EnablePreemptibleNodepool bool   `json:"enablePreemptibleNodepool"`
	DefaultNodepoolOS         string `json:"defaultNodepoolOS"`
	PrivateEndpoint           bool   `json:"privateEndpoint"`
	EnableConfigSync          bool   `json:"enableConfigSync"`
	EnablePolicyController    bool   `json:"enablePolicyController"`
	AnthosServiceMesh         bool   `json:"anthosServiceMesh"`
	MultiClusterGateway       bool   `json:"multiClusterGateway"`
	VPCType                   string `json:"vpcType"`
	ClusterIndex              int    `json:"clusterIndex"`
	ClusterType               string `json:"clusterType"`
	ClusterMachineType        string `json:"clusterMachineType"`
	ClusterRegion             string `json:"clusterRegion"`
	ClusterZone               string `json:"clusterZone"`
}

func SendAnalytics(conf *config.Config, version string, gitCommit string) {
	// Generate timestamp. Format: 2006-01-02T15:04:05.000Z
	now := time.Now()
	timestamp := now.Format("2006-01-02T15:04:05.000Z")

	// Generate CreateId used by all clusters

	// Assign UUIDs to create run and cluster
	createId, err := uuid.NewV4()
	if err != nil {
		log.Warn(err)
		return
	}

	for i, cluster := range conf.ClustersConfig {
		// Cluster Id
		clusterId, err := uuid.NewV4()
		if err != nil {
			log.Warn(err)
			return
		}

		// Create Cluster Object, omitting any user-identified data (Project IDs)
		// NOTE - ClusterId and CreateId are generated server-side before DB insert to avoid HTTP POST anti-patterns
		sendObject := Cluster{
			ClusterId:                 clusterId.String(),
			CreateId:                  createId.String(),
			Version:                   version,
			GitCommit:                 gitCommit,
			Timestamp:                 timestamp,
			OS:                        runtime.GOOS,
			TerraformState:            conf.TerraformState,
			Region:                    conf.Region,
			EnablePreemptibleNodepool: conf.EnablePreemptibleNodepool,
			DefaultNodepoolOS:         conf.DefaultNodepoolOS,
			PrivateEndpoint:           conf.PrivateEndpoint,
			EnableConfigSync:          conf.ConfigSync,
			EnablePolicyController:    conf.PolicyController,
			AnthosServiceMesh:         conf.AnthosServiceMesh,
			MultiClusterGateway:       conf.MultiClusterGateway,
			VPCType:                   conf.VpcConfig.VpcType,
			ClusterIndex:              i,
			ClusterType:               cluster.ClusterType,
			ClusterMachineType:        cluster.MachineType,
			ClusterRegion:             cluster.Region,
			ClusterZone:               cluster.Zone,
		}
		// Encode as JSON
		json, err := json.Marshal(sendObject)
		if err != nil {
			log.Warn(err)
			return
		}
		err = PostToAnalyticsServer(json)
		if err != nil {
			log.Warn(err)
			return
		}
	}
	log.Info("✅ Sent cluster info to analytics server")
	return
}

func PostToAnalyticsServer(json []byte) error {
	url := "https://analytics.gkepoctoolkit.dev"
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(json))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	return nil
}
