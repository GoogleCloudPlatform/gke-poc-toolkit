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
gcloud container clusters get-credentials ${CLUSTER} --region ${LOCATION} --project ${PROJECT_ID}

# Verify CRD is established in the cluster
echo -e "Verifying Control Plane Revisions CRD is present on ${CLUSTER}"
until kubectl get mutatingwebhookconfigurations istiod-asm-managed --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}
  do
    echo -n "...still waiting for ASM MCP webhook creation"
    sleep 1
  done

# Install SAs, Roles, Roledbinding for ASM
kubectl apply -f ./manifests/istio-system-ns.yaml --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}
kubectl apply -f ./manifests/ --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}

kubectl wait --for=condition=ProvisioningFinished controlplanerevision -n istio-system asm-managed --timeout=10m --kubeconfig ${KUBECONFIG} --context=gke_${PROJECT_ID}_${LOCATION}_${CLUSTER}