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
	"fmt"
	"html/template"
	"os"
	"strings"

	"cloud.google.com/go/storage"
	log "github.com/sirupsen/logrus"
	"github.com/thanhpk/randstr"
)

func CheckTfStateType(conf *Config, bucketNameClusters string, bucketNameSharedVPC string) error {
	if conf.TerraformState == "cloud" {
		if conf.VpcConfig.VpcType == "shared" {
			if bucketNameSharedVPC == "" {
				bucketNameSharedVPC := "tf-state-sharedvpc-" + strings.ToLower(randstr.String(6))
				err := createTfStorage(conf.VpcConfig.VpcProjectID, bucketNameSharedVPC)
				if err != nil {
					return err
				}
			}
			err := createTfBackend(bucketNameSharedVPC, "shared_vpc/backend.tf")
			if err != nil {
				return err
			}
		}
		if bucketNameClusters == "" {
			log.Infof("Clusters Bucket Name: %s", bucketNameClusters)
			bucketNameClusters := "tf-state-clusters-" + strings.ToLower(randstr.String(6))
			err := createTfStorage(conf.ClustersProjectID, bucketNameClusters)
			if err != nil {
				return err
			}
		}
		err := createTfBackend(bucketNameClusters, "cluster_build/backend.tf")
		if err != nil {
			return err
		}
		return nil
	}
	return nil
}

// func CreateTfStateBucket(projectId string, bucketName string) error {
func createTfStorage(projectId string, bucketName string) error {
	ctx := context.Background()
	c, err := storage.NewClient(ctx)
	if err != nil {
		return err
	}
	attrs, err := c.Bucket(bucketName).Attrs(ctx)
	if err == storage.ErrBucketNotExist {
		log.Infof("Creating storage bucket: %s ", bucketName)
		err = c.Bucket(bucketName).Create(ctx, projectId, nil)
		if err != nil {
			log.Fatalf("error creating storage bucket: %s", err)
			return err
		}
	} else {
		fmt.Printf("The bucket exists and has attributes: %#v\n", attrs)
	}
	return err
}

func createTfBackend(bucketName string, fileLocation string) error {
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
