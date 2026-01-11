#!/bin/bash
# scripts/cleanup-k8s-resources.sh

CLUSTER_NAME=$1
REGION=$2

if [ -z "$CLUSTER_NAME" ] || [ -z "$REGION" ]; then
  echo "Usage: $0 <cluster_name> <region>"
  exit 1
fi

echo "Configuring kubectl for cluster $CLUSTER_NAME in region $REGION..."
aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$REGION"

# Helper function to delete resources if they exist
delete_if_exists() {
  RESOURCE_TYPE=$1
  DISPLAY_NAME=$2

  echo "Checking $DISPLAY_NAME..."
  # Check if any resources of this type exist
  if kubectl get "$RESOURCE_TYPE" --all-namespaces --no-headers 2>/dev/null | grep -q .; then
    echo "Found $DISPLAY_NAME. Deleting..."
    kubectl delete "$RESOURCE_TYPE" --all --all-namespaces --timeout=5m || echo "Warning: Failed to delete some $DISPLAY_NAME"
  else
    echo "No $DISPLAY_NAME found. Skipping."
  fi
}

delete_if_exists "ingress" "Ingress resources"
delete_if_exists "svc --field-selector spec.type=LoadBalancer" "LoadBalancer Services"
delete_if_exists "pvc" "PVCs"

echo "Checking VolumeSnapshots..."
if kubectl api-resources | grep -q volumesnapshots; then
  delete_if_exists "volumesnapshots" "VolumeSnapshots"
else
  echo "VolumeSnapshot CRD not found. Skipping."
fi

echo "Cleanup commands triggered. Waiting 30s for controllers to process deletion..."
sleep 30
