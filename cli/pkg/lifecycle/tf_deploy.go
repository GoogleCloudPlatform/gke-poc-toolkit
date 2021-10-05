package lifecycle

import (
	"context"
	"io/ioutil"
	"os"

	log "github.com/sirupsen/logrus"

	"github.com/hashicorp/terraform-exec/tfexec"
	"github.com/hashicorp/terraform-exec/tfinstall"
)

func InitTF(tfDir string) {
	tmpDir, err := ioutil.TempDir("", "tfinstall")
	if err != nil {
		log.Fatalf("error creating temp dir: %s", err)
	}
	defer os.RemoveAll(tmpDir)

	execPath, err := tfinstall.Find(context.Background(), tfinstall.LatestVersion(tmpDir, false))
	if err != nil {
		log.Fatalf("error locating Terraform binary: %s", err)
	}

	// workingDir := "../terraform/cluster_build"
	tf, err := tfexec.NewTerraform(tfDir, execPath)
	if err != nil {
		log.Fatalf("error running NewTerraform: %s", err)
	}

	tf.SetStdout(log.StandardLogger().Out)

	err = tf.Init(context.Background(), tfexec.Upgrade(true))
	if err != nil {
		log.Fatalf("error running Init: %s", err)
	}

	state, err := tf.Show(context.Background())
	if err != nil {
		log.Fatalf("error running Show: %s", err)
	}

	log.Println(state.FormatVersion) // "0.1"

	plan, err := tf.Plan(context.Background(), tfexec.VarFile("../../cli/terraform.tfvars"))
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

	// workingDir := "../terraform/cluster_build"
	tf, err := tfexec.NewTerraform(tfDir, execPath)
	if err != nil {
		log.Fatalf("error running NewTerraform: %s", err)
	}

	tf.SetStdout(os.Stdout)

	err = tf.Apply(context.Background(), tfexec.VarFile("../../cli/terraform.tfvars"))
	if err != nil {
		log.Fatalf("error running Apply: %s", err)
	}
}
