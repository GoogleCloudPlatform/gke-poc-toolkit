apiVersion: mesh.cloud.google.com/v1alpha1
kind: ControlPlaneRevision
metadata:
  name: asm-managed
  namespace: istio-system
spec:
  type: managed_service
  channel: ${asm_release_channel}