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

package lifecycle

import (
	"context"
	"html/template"
	"io/ioutil"
	"os"

	log "github.com/sirupsen/logrus"

	"github.com/hashicorp/terraform-exec/tfexec"
	"github.com/hashicorp/terraform-exec/tfinstall"
)

func InitTF(tfDir string, tfStateBucket string) {
	tmpDir, err := ioutil.TempDir("", "tfinstall")
	if err != nil {
		log.Fatalf("error creating temp dir: %s", err)
	}
	defer os.RemoveAll(tmpDir)

	execPath, err := tfinstall.Find(context.Background(), tfinstall.LatestVersion(tmpDir, false))
	if err != nil {
		log.Fatalf("error locating Terraform binary: %s", err)
	}

	tf, err := tfexec.NewTerraform(tfDir, execPath)
	if err != nil {
		log.Fatalf("error running NewTerraform: %s", err)
	}

	tf.SetStdout(log.StandardLogger().Out)

	backEndFile := tfDir + "/backend.tf"
	if tfStateBucket != "local" {
		createTfBackend(tfStateBucket, backEndFile)
	}

	err = tf.Init(context.Background(), tfexec.Upgrade(true))
	if err != nil {
		log.Fatalf("error running Init: %s", err)
	}

	state, err := tf.Show(context.Background())
	if err != nil {
		log.Fatalf("error running Show: %s", err)
	}

	log.Println(state.FormatVersion) // "0.1"

	plan, err := tf.Plan(context.Background(), tfexec.VarFile("../terraform.tfvars"))
	if err != nil {
		log.Fatalf("error running Plan: %s", err)
	}
	log.Println(plan)
}

func ApplyTF(tfDir string) {
	tmpDir, err := ioutil.TempDir("", "tfinstall")
	if err != nil {
		log.Fatalf("error creating temp dir: %s", err)
	}
	defer os.RemoveAll(tmpDir)

	execPath, err := tfinstall.Find(context.Background(), tfinstall.LatestVersion(tmpDir, false))
	if err != nil {
		log.Fatalf("error locating Terraform binary: %s", err)
	}

	tf, err := tfexec.NewTerraform(tfDir, execPath)
	if err != nil {
		log.Fatalf("error running NewTerraform: %s", err)
	}

	tf.SetStdout(os.Stdout)

	err = tf.Apply(context.Background(), tfexec.VarFile("../terraform.tfvars"))
	if err != nil {
		log.Fatalf("error running Apply: %s", err)
	}
}

func createTfBackend(tfStateBucket string, fileLocation string) {
	vars := make(map[string]interface{})
	vars["TfStateBucket"] = tfStateBucket
	tmpl, err := template.ParseFiles("templates/terraform_backend.tf.tmpl")
	if err != nil {
		log.Fatalf("error parsing template: %s", err)
	}
	file, err := os.Create(fileLocation)
	if err != nil {
		log.Fatalf("error creating file: %s", err)
	}
	defer file.Close()
	err = tmpl.Execute(file, vars)
	if err != nil {
		log.Fatalf("error executing tffavs template merge: %s", err)
	}
}
