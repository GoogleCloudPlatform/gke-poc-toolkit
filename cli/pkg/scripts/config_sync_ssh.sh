#!/bin/sh
set -x 

# Generate SSH Key pair 
# https://cloud.google.com/anthos-config-management/docs/how-to/installing-config-sync#ssh-key-pair 
# https://cloud.google.com/source-repositories/docs/authentication#ssh 
mkdir -p ../../pkg/scripts/.ssh

GCP_EMAIL=`gcloud config list account --format "value(core.account)"`
ssh-keygen -t rsa -b 4096 \
-C $GCP_EMAIL \
-N '' \
-f ../../pkg/scripts/.ssh/id_rsa


# Ask the user to copy the public key to the clipboard and register it in CSR 
# (THIS HAS TO BE DONE IN THE CLOUD CONSOLE, UNFORTUNATALY) 

echo "⭐️ COPY THE FOLLOWING PUBLIC KEY TO THE CLIPBOARD:"
cat "../../pkg/scripts/.ssh/id_rsa.pub"
read -p "Press Enter to continue..."


echo "⭐ Now go to this link to register the key to Cloud Source Repositories:"
echo "https://source.cloud.google.com/user/ssh_keys?register=true" 


read -p "🏁 Press Enter to continue..."
