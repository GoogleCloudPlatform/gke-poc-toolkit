# CI Project Cleanup job 

This directory contains the Dockerfile and bash script for a Cloud Run service that periodically deletes CI projects older than 6 hours.

The reason we have a job for this, rather than a Cloud Build cleanup step in the pipeline, is because if a job fails, the Cloud Build pipeline will stop abruptly and not clean up the project. 
Cloud Build doesn't have a good way to "jump to" or "cleanup" in the case of a failed build. So this Cloud Run service does a periodic sweep through the test project folder and cleans up old projects.  

The image can be found here: `gcr.io/gkepoctoolkit/ci-project-cleanup:latest`

Note that this image must be configured with a service account key and GCP project folder ID to watch. We use the Cloud Run + Secret Manager integration to pass this sensitive data as env vars. 
