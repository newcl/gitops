# Installing ArgoCD

This guide provides instructions for installing ArgoCD using either kubectl or Helm.

## Prerequisites

- A running Kubernetes cluster
- kubectl configured to communicate with your cluster
- (Optional) Helm 3.x if using Helm installation method

## Method 1: Install using kubectl (Recommended)

1. Create the ArgoCD namespace:
```bash
kubectl create namespace argocd
```

2. Apply the ArgoCD installation manifests:
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

3. Wait for all pods to be running:
```bash
kubectl get pods -n argocd -w
```

4. Get the ArgoCD admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

5. Port-forward the ArgoCD server:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

6. Access the ArgoCD UI:
   - Open your browser and navigate to https://localhost:8080
   - Login with:
     - Username: admin
     - Password: (the password from step 4)

## Method 2: Install using Helm

1. Add the Argo Helm repository:
```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

2. Install ArgoCD:
```bash
helm install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --set server.extraArgs="{--insecure}" \
  --set server.service.type=LoadBalancer
```

3. Get the ArgoCD admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

4. Access the ArgoCD UI:
   - If using LoadBalancer, get the external IP:
     ```bash
     kubectl get svc -n argocd argocd-server
     ```
   - Open your browser and navigate to https://<EXTERNAL-IP>
   - Login with:
     - Username: admin
     - Password: (the password from step 3)

## Post-Installation Steps

1. Change the default admin password:
```bash
argocd account update-password
```

2. Install the ArgoCD CLI (optional but recommended):
```bash
# For Linux
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# For macOS
brew install argocd
```

3. Login to ArgoCD using CLI:
```bash
argocd login <ARGOCD_SERVER> --username admin --password <PASSWORD>
```

## Troubleshooting

1. If pods are not starting, check the events:
```bash
kubectl get events -n argocd
```

2. Check pod logs:
```bash
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
```

3. If you can't access the UI, verify the service:
```bash
kubectl get svc -n argocd argocd-server
```

## Security Considerations

1. Change the default admin password immediately after installation
2. Consider setting up SSO integration
3. Use RBAC to restrict access
4. Enable TLS for the ArgoCD server
5. Consider using sealed secrets or external secret management for sensitive data

## Next Steps

After installation, you can:
1. Configure your first application
2. Set up Git repositories
3. Configure RBAC
4. Set up SSO (if needed)
5. Configure notifications 