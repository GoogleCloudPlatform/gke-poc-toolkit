package cli_init

import (
	"bytes"
	"embed"
	"io/ioutil"
	"os"

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
	log.Info("✅ gkekitctl initialized successfully.")
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
