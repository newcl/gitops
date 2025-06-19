# MinIO Installation for Dev Cluster (GitOps)

This guide documents the steps to install MinIO in single-node mode using the local-path provisioner, with 20Gi storage and randomly generated credentials. All manifests are rendered for GitOps tracking.

## Steps

1. **Add MinIO Helm Repository**
   - The script adds the official MinIO Helm chart repository and updates the repo index.

2. **Generate Random Credentials**
   - Secure random credentials for `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD` are generated for your deployment.

3. **Create `minio-values.yaml`**
   - A custom values file is created with:
     - Standalone mode
     - 20Gi persistent storage
     - Local-path storage class
     - The generated credentials

4. **Render Manifests for GitOps**
   - Helm is used to render the manifests into `apps/minio/base/minio.yaml` for GitOps tracking. No resources are directly applied to the cluster by the script.
   - An Ingress resource is added for Traefik, exposing MinIO at `minio.elladali.com` on HTTP (port 9000) and `mconsole.elladali.com` (web UI, port 9001).
   - The manifests are now split into separate files (`minio.yaml`, `ingress.yaml`) and managed with Kustomize (`kustomization.yaml`).
   - Use Kustomize to render the final manifests:
     ```bash
     kustomize build apps/minio/base > apps/minio/base/minio-rendered.yaml
     ```

5. **Next Steps**
   - Review the generated manifests in `apps/minio/base/minio.yaml`.
   - Commit them to your GitOps repository.
   - Apply them to your dev cluster using your GitOps workflow.

---

## Usage

- To render manifests for GitOps, use:
  ```bash
  kustomize build apps/minio/base > apps/minio/base/minio-rendered.yaml
  ```
- The rendered file will include all resources (MinIO, Ingress, etc.)
- To apply the changes to your cluster:
  ```bash
  kubectl apply -f apps/minio/base/minio-rendered.yaml
  ```
- Access the MinIO API at: [http://minio.elladali.com/](http://minio.elladali.com/)
- Access the MinIO web UI at: [http://mconsole.elladali.com/](http://mconsole.elladali.com/)

Run the following script from the project root:

```bash
bash install_minio.sh
```

This will:
- Generate random credentials
- Create a values file
- Render manifests for GitOps

The credentials will be printed to the console. Store them securely.

---

## Notes
- This setup is for development/testing. For production, review MinIO and Kubernetes best practices.
- The local-path provisioner must be available in your cluster.
- The namespace `minio` will be created if it does not exist.
- Ensure your DNS for `minio.elladali.com` and `mconsole.elladali.com` points to your Traefik ingress controller. 