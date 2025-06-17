# Installation Guide

## ArgoCD Installation

ArgoCD is installed using GitOps practices with Kustomize. The installation is managed through the following directory structure:

```
apps/argocd/
├── base/              # Base ArgoCD installation
│   ├── install.yaml   # Official ArgoCD manifest
│   └── kustomization.yaml
└── overlays/
    └── dev/          # Development environment specific configurations
        ├── ingress.yaml
        └── kustomization.yaml
```

### Prerequisites

- Kubernetes cluster
- kubectl configured to access the cluster
- kustomize installed

### Installation Steps

1. Apply the ArgoCD installation using kustomize:

```bash
kubectl apply -k apps/argocd/overlays/dev
```

2. Wait for all ArgoCD pods to be running:

```bash
kubectl get pods -n argocd -w
```

3. Access ArgoCD UI:
   - URL: http://argo.elladali.com
   - Note: HTTPS is handled by Cloudflare

### Default Credentials

The default admin password is stored in a Kubernetes secret. To retrieve it:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Security Note

- ArgoCD is configured to use HTTP only, as HTTPS termination is handled by Cloudflare
- The admin password should be changed after first login
- Consider implementing additional security measures as needed

### Updating ArgoCD

To update ArgoCD to a new version:

1. Update the version in the base/install.yaml file
2. Apply the changes:

```bash
kubectl apply -k apps/argocd/overlays/dev
```

### Troubleshooting

If you encounter any issues:

1. Check the ArgoCD pods status:
```bash
kubectl get pods -n argocd
```

2. Check the ArgoCD server logs:
```bash
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
```

3. Verify the ingress configuration:
```bash
kubectl get ingress -n argocd
```

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