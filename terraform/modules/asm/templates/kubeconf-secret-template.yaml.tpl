apiVersion: v1
data:
  ${cluster}: ${kubeconfig}
kind: Secret
metadata:
  name: ${cluster}
  labels:
    istio/multiCluster: "true"
  annotations:
    networking.istio.io/cluster: ${cluster}
  namespace: istio-system