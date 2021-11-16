package cli_init

import (
	"bytes"
	"embed"
	"io/ioutil"
	"log"
	"os"
)

//go:embed templates/* samples/* cluster_build/* shared_vpc/*
var templates embed.FS

func InitFlatFiles(folders []string) {
	for _, folder := range folders {
		files := CreateFileList("pkg/cli_init/" + folder)
		var buf bytes.Buffer
		for _, file := range files {
			b, err := templates.ReadFile(folder + "/" + file)
			if err != nil {
				log.Fatalf("error reading %s: %s", file, err)
			}
			if _, err := os.Stat(folder); os.IsNotExist(err) {
				os.MkdirAll(folder, 0700)
			}
			buf.Write(b)
			err = ioutil.WriteFile(folder+"/"+file, buf.Bytes(), 0644)
			if err != nil {
				log.Fatalf("error creating file %s: %s", file, err)
			}
			buf.Reset()
		}
	}
}

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
