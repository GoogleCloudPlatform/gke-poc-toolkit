#!/bin/bash
export GPT_TEST_FOLDER_ID="673643246072"
echo "Folder ID is: $GPT_TEST_FOLDER_ID"

while true
do
    echo "Deleting all projects more than 6hr old in folder: $GPT_TEST_FOLDER_ID" 
    gcloud projects list --filter="parent.id=$GPT_TEST_FOLDER_ID AND parent.type=folder" --format='value(project_id)' | while read project_id; do 
        CREATE_TIME=`gcloud projects describe $project_id --format='value(createTime)'`
        echo "Project: $project_id created at: $CREATE_TIME" 
        SIX_HOURS_AGO=`date -d '6 hour ago' "+%Y-%m-%dT%H:%M:%SZ"`
        if [[ $CREATE_TIME < $SIX_HOURS_AGO ]]; then 
            gcloud alpha resource-manager liens list --project $project_id --format='value(name)' | while read lien; do 
                echo "🗑 Deleting lien: $lien"
                gcloud alpha resource-manager liens delete $lien --project $project_id
            done

            echo "🌎 Removing shared vpc permissions on test project folder for serviceAccount:e2e-test@$project_id.iam.gserviceaccount.com..."            
            gcloud beta resource-manager folders remove-iam-policy-binding $GPT_TEST_FOLDER_ID --member="serviceAccount:e2e-test@$project_id.iam.gserviceaccount.com" --role="roles/compute.xpnAdmin"    

            echo "❌ Deleting project: $project_id"
            gcloud projects delete --quiet $project_id
        else
            echo "✅ Project $project_id is newer than 6 hours (it was created at $CREATE_TIME), keeping..."
        fi
    done
    sleep 600
done
