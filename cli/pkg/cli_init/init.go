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

package cli_init

import (
	"bytes"
	"embed"
	"fmt"
	"io/ioutil"
	"os"
	"strings"

	"github.com/manifoldco/promptui"

	log "github.com/sirupsen/logrus"
)

// embeding flatfiles and setting them as a file system variable, embed.FS.
// embed.FS can be treated like io.FS.

//go:embed templates/* samples/* cluster_build/* shared_vpc/*
var templates embed.FS

func InitFlatFiles(folders []string) error {
	log.Info("🔄 Initializing flat files for gkekitctl...")

	// Range over embedded folders of flat files
	for _, folder := range folders {
		files, err := templates.ReadDir(folder)
		if err != nil {
			return err
		}
		var buf bytes.Buffer

		// Range over embed files in folder and write them out to the directory gkekitctl is running inside
		for _, file := range files {
			b, err := templates.ReadFile(folder + "/" + file.Name())
			if err != nil {
				return err
			}
			if _, err := os.Stat(folder); os.IsNotExist(err) {
				os.MkdirAll(folder, 0700)
			}
			buf.Write(b)
			err = ioutil.WriteFile(folder+"/"+file.Name(), buf.Bytes(), 0644)
			if err != nil {
				return err
			}
			buf.Reset()
		}
	}
	return nil
}

// Helper function to create a list of files from a folder
func CreateFileList(dir string) []string {
	files_out := []string{}
	folder, err := os.Open(dir)
	if err != nil {
		log.Fatal(err)
	}
	files, err := folder.Readdir(-1)
	folder.Close()
	if err != nil {
		log.Fatal(err)
	}
	for _, file := range files {
		files_out = append(files_out, file.Name())
	}
	return files_out
}

// Prompt user to opt into anonymous analytics
func OptInAnalytics() error {
	log.Info("📊 Send anonymous analytics to GKE PoC Toolkit maintainers?")
	sendAnalytics := yesNo()
	if !sendAnalytics {
		return nil
	}
	// Write opt-in to all config files
	files, err := ioutil.ReadDir("./samples")
	if err != nil {
		return err
	}

	for _, f := range files {
		log.Infof("Processing file: %s", f.Name())
		err := addOptInAnalyticsToConfigFile(fmt.Sprintf("samples/%s", f.Name()))
		if err != nil {
			return err
		}
	}
	return nil
}

// Source: https://stackoverflow.com/questions/55176623/how-to-ask-yes-or-no-using-golang
func yesNo() bool {
	prompt := promptui.Select{
		Label: "Select[Yes/No]",
		Items: []string{"Yes", "No"},
	}
	_, result, err := prompt.Run()
	if err != nil {
		log.Warnf("Prompt failed %v\n", err)
	}
	result = strings.ToUpper(result)
	return result == "YES"
}

func addOptInAnalyticsToConfigFile(f string) error {
	input, err := ioutil.ReadFile(f)
	if err != nil {
		return err
	}

	lines := strings.Split(string(input), "\n")

	for i, line := range lines {
		if strings.Contains(line, "sendAnalytics") {
			lines[i] = "sendAnalytics: true"
		}
	}
	output := strings.Join(lines, "\n")
	err = ioutil.WriteFile(f, []byte(output), 0644)
	if err != nil {
		return err
	}
	return nil
}
