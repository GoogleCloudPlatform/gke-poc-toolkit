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
	"html/template"
	"os"
	"strings"

	"cloud.google.com/go/storage"
	log "github.com/sirupsen/logrus"
	"github.com/thanhpk/randstr"
)

func CheckTfStateType(conf *Config) error {
	if conf.TerraformState == "cloud" {
		bucketNames := [3]string{}
		if conf.VpcConfig.VpcType == "shared" {
			bucketNameSharedVPC := "tf-state-sharedvpc-" + strings.ToLower(randstr.String(6))
			err := createTfBackend(conf.VpcConfig.VpcProjectID, bucketNameSharedVPC, "shared_vpc/backend.tf")
			if err != nil {
				return err
			}
		}
		bucketNameClusters := "tf-state-clusters-" + strings.ToLower(randstr.String(6))
		err := createTfBackend(conf.ClustersProjectID, bucketNameClusters, "cluster_build/backend.tf")
		if err != nil {
			return err
		}
		log.Print(bucketNames)
		return nil
	}
	return nil
}

// func CreateTfStateBucket(projectId string, bucketName string) error {
func createTfBackend(projectId string, bucketName string, fileLocation string) error {
	ctx := context.Background()
	c, err := storage.NewClient(ctx)
	if err != nil {
		log.Fatalf("error creating storage client: %s", err)
		return err
	}
	err = c.Bucket(bucketName).Create(ctx, projectId, nil)
	if err != nil {
		log.Fatalf("error creating storage bucket: %s", err)
		return err
	}
	vars := make(map[string]interface{})
	vars["TfStateBucket"] = bucketName
	tmpl, err := template.ParseFiles("templates/terraform_backend.tf.tmpl")
	if err != nil {
		log.Fatalf("error parsing template: %s", err)
		return err
	}
	file, err := os.Create(fileLocation)
	if err != nil {
		log.Fatalf("error creating file: %s", err)
		return err
	}
	defer file.Close()
	err = tmpl.Execute(file, vars)
	if err != nil {
		log.Fatalf("error executing tffavs template merge: %s", err)
		return err
	}
	return nil
}
