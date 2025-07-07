#!/bin/bash
set -euo pipefail

echo "Installing Strimzi Cluster Operator..."

# Install operator first
kubectl apply -f apps/base/kafka/namespace.yaml
kubectl apply -f apps/base/kafka/strimzi-cluster-operator-install.yaml

# Wait for CRDs to be established
echo "Waiting for Kafka CRDs to be ready..."
kubectl wait --for=condition=established --timeout=120s crd/kafkas.kafka.strimzi.io
kubectl wait --for=condition=established --timeout=120s crd/kafkausers.kafka.strimzi.io
kubectl wait --for=condition=established --timeout=120s crd/kafkatopics.kafka.strimzi.io

# Wait for operator to be ready
echo "Waiting for Strimzi operator to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/strimzi-cluster-operator -n kafka

# Install Kafka cluster
echo "Installing Kafka cluster..."
kubectl apply -f apps/base/kafka/kafka-cluster.yaml

echo "Kafka installation completed!" 