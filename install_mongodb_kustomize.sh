#!/usr/bin/env bash
set -euo pipefail

echo "Installing MongoDB using GitOps manifests..."

# 1. Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed or not in PATH"
    exit 1
fi

# 2. Check if k3s is running
if ! kubectl cluster-info &> /dev/null; then
    echo "Error: Cannot connect to Kubernetes cluster. Make sure k3s is running."
    exit 1
fi

# 3. Apply MongoDB manifests using kustomize
echo "Applying MongoDB manifests..."
kubectl apply -k apps/mongodb/base/

# 4. Wait for namespace to be created
echo "Waiting for MongoDB namespace to be created..."
kubectl wait --for=condition=Active namespace/mongodb --timeout=60s

# 5. Wait for MongoDB deployment to be ready
echo "Waiting for MongoDB deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/mongodb -n mongodb

# 6. Wait for MongoDB init job to complete
echo "Waiting for MongoDB initialization job to complete..."
kubectl wait --for=condition=complete --timeout=300s job/mongodb-init -n mongodb

# 7. Check the status
echo "Checking MongoDB status..."
kubectl get pods -n mongodb
kubectl get svc -n mongodb
kubectl get pvc -n mongodb

echo ""
echo "MongoDB installation completed successfully!"
echo ""
echo "Connection details:"
echo "- Internal Host: mongodb.mongodb.svc.cluster.local"
echo "- Port: 27017"
echo "- Database: appdb"
echo "- Username: mongodb"
echo "- Password: MongoDB123!"
echo ""
echo "Connection string:"
echo "mongodb://mongodb:MongoDB123!@mongodb.mongodb.svc.cluster.local:27017/appdb"
echo ""
echo "To connect from within the cluster:"
echo "kubectl exec -it -n mongodb deployment/mongodb -- mongosh --username mongodb --password MongoDB123! --authenticationDatabase admin"
echo ""
echo "⚠️  Remember to change the default passwords in production!" 