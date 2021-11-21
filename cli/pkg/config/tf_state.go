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

package config

import (
	"context"
	"strings"

	"cloud.google.com/go/storage"
	log "github.com/sirupsen/logrus"
	"github.com/thanhpk/randstr"
)

func CheckTfStateType(conf *Config) ([]string, error) {
	if conf.TerraformState == "cloud" && conf.VpcConfig.VpcType == "shared" {
		bucketNameClusters := "tf-state-clusters" + strings.ToLower(randstr.String(6))
		bucketNameSharedVPC := "tf-state-sharedvpc" + strings.ToLower(randstr.String(6))
		CreateTfStateBucket(conf.ClustersProjectID, bucketNameClusters)
		CreateTfStateBucket(conf.VpcConfig.VpcProjectID, bucketNameSharedVPC)
		bucketNames := []string{bucketNameClusters, bucketNameSharedVPC}
		return bucketNames, nil
	} else if conf.TerraformState == "cloud" && conf.VpcConfig.VpcType == "standalone" {
		bucketNameClusters := "tf-state-clusters" + strings.ToLower(randstr.String(6))
		CreateTfStateBucket(conf.ClustersProjectID, bucketNameClusters)
		bucketNames := []string{bucketNameClusters}
		return bucketNames, nil
	}
	return []string{"local", "local"}, nil
}

// func CreateTfStateBucket(projectId string, bucketName string) error {
func CreateTfStateBucket(projectId string, bucketName string) {
	ctx := context.Background()
	c, err := storage.NewClient(ctx)
	if err != nil {
		log.Fatalf("error creating storage client: %s", err)
	}
	err = c.Bucket(bucketName).Create(ctx, projectId, nil)
	if err != nil {
		log.Fatalf("error creating storage bucket: %s", err)
	}
}
