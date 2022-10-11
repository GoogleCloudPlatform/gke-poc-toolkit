#!/usr/bin/env bash

# Verify variables
echo -e "Project is ${PROJECT_ID}"
echo -e "CLUSTER is ${CLUSTER}"
echo -e "LOCATION is ${LOCATION}"
#echo -e "ASM_PACKAGE is ${ASM_PACKAGE}"

export WORKDIR=`pwd`
kubeconfig=tempkubeconfig$RANDOM
echo -e "Adding cluster ${CLUSTER} to kubeconfig located at ${WORKDIR}/tempkubeconfig"
echo -e "Creating tempkubeconfig."
rm ${WORKDIR}/${kubeconfig}
touch ${WORKDIR}/${kubeconfig}
export KUBECONFIG=${WORKDIR}/${kubeconfig}

# Get cluster creds
gcloud beta container fleet memberships get-credentials ${CLUSTER}-membership --project ${PROJECT_ID}
#gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT_ID}

CONTEXT=`kubectl config view -o jsonpath='{.users[*].name}' --kubeconfig ${KUBECONFIG} | grep ${CLUSTER}`
# Verify CRD is established in the cluster
echo -e "Verifying Control Plane Revisions CRD is present on ${CLUSTER}"
until kubectl get crd controlplanerevisions.mesh.cloud.google.com --kubeconfig ${KUBECONFIG} --context=${CONTEXT}
  do
    echo -n "...still waiting for the control plan revision crd creation"
    sleep 1
  done

# Install SAs, Roles, Roledbinding for ASM
kubectl apply -f ./manifests/istio-system-ns.yaml --kubeconfig ${KUBECONFIG} --context=${CONTEXT}
kubectl apply -f ./manifests/ --kubeconfig ${KUBECONFIG} --context=${CONTEXT}

kubectl wait --for=condition=ProvisioningFinished controlplanerevision -n istio-system asm-managed --timeout=10m --kubeconfig ${KUBECONFIG} --context=${CONTEXT}