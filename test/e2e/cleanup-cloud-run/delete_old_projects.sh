#!/bin/bash
echo "Folder ID is: $GPT_TEST_FOLDER_ID"
echo "SA Key is: $GPT_TEST_SA_KEY, writing to file..." 

python3 -m http.server 8080 &

export KEY_PATH="sa_key.json"
echo $GPT_TEST_SA_KEY > $KEY_PATH
export GOOGLE_APPLICATION_CREDENTIALS=$KEY_PATH

while true
do
    echo "Deleting all projects more than 6hr old in folder: $GPT_TEST_FOLDER_ID" 
    gcloud projects list --filter="parent.id=$GPT_TEST_FOLDER_ID AND parent.type=folder" --format='value(project_id)' | while read project_id; do 
        CREATE_TIME=`gcloud projects describe $project_id --format='value(createTime)'`
        echo "Project: $project_id created at: $CREATE_TIME" 
        SIX_HOURS_AGO=`date -d '6 hour ago' "+%Y-%m-%dT%H:%M:%SZ"`
        if [[ $CREATE_TIME < $SIX_HOURS_AGO ]]; then 
            gcloud beta resource-manager folders remove-iam-policy-binding $GPT_TEST_FOLDER_ID --member="serviceAccount:e2e-test@$project_id.iam.gserviceaccount.com" --role="roles/compute.xpnAdmin"    
            echo "🧹 Project $project_id is older than 6 hours (it was created at $CREATE_TIME), deleting..."
            gcloud projects delete --quiet $project_id
        else
            echo "🌟 Project $project_id is newer than 6 hours (it was created at $CREATE_TIME), keeping..."
        fi
    done
    sleep 600
done
