#!/usr/bin/env bash
set -euo pipefail

# 1. Add MinIO Helm repo and update
helm repo add minio https://charts.min.io/ || true
helm repo update

# 2. Generate random credentials for MinIO
export MINIO_ROOT_USER="minio-$(head -c 6 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 8)"
export MINIO_ROOT_PASSWORD="$(head -c 16 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 20)"
echo "Generated MINIO_ROOT_USER: $MINIO_ROOT_USER"
echo "Generated MINIO_ROOT_PASSWORD: $MINIO_ROOT_PASSWORD"

# 3. Create a values.yaml for MinIO with local path provisioner and 20G storage
cat <<EOF > minio-values.yaml
mode: standalone
rootUser: "$MINIO_ROOT_USER"
rootPassword: "$MINIO_ROOT_PASSWORD"
persistence:
  enabled: true
  size: 20Gi
  storageClass: "local-path"
resources: {}
EOF

echo "minio-values.yaml created."

# 4. Render manifests for GitOps tracking
mkdir -p apps/minio/base
helm template minio minio/minio -n minio --create-namespace -f minio-values.yaml > apps/minio/base/minio.yaml

echo "Rendered manifests to apps/minio/base/minio.yaml."

# 5. Print next steps
cat <<EOM
MinIO manifests are rendered in apps/minio/base/minio.yaml.
Add these files to your GitOps repo and apply them to your dev cluster.
EOM 