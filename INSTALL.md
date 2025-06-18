# ArgoCD Installation Guide

This guide documents the installation and configuration of ArgoCD in our Kubernetes cluster.

## Prerequisites

- Kubernetes cluster (k3s)
- kubectl configured to access the cluster
- nginx ingress controller installed
- Cloudflare Tunnel configured for secure access

## Installation Steps

1. Create the ArgoCD namespace:
```bash
kubectl create namespace argocd
```

2. Apply the ArgoCD configuration:
```bash
kubectl apply -k apps/argocd/overlays/dev
```

3. Wait for all pods to be ready:
```bash
kubectl get pods -n argocd -w
```

4. Get the initial admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Accessing ArgoCD

ArgoCD is configured to run in insecure mode behind Cloudflare Tunnel:
- URL: https://argocd.elladali.com
- Username: admin
- Password: (from step 4)

## Configuration Details

The installation uses the following customizations:
- Insecure mode enabled for Cloudflare Tunnel compatibility
- HTTP backend protocol for nginx ingress
- Custom hostname: argocd.elladali.com

## Troubleshooting

If you encounter any issues:
1. Check pod status: `kubectl get pods -n argocd`
2. Check pod logs: `kubectl logs -n argocd <pod-name>`
3. Verify ingress configuration: `kubectl get ingress -n argocd`
4. Check Cloudflare Tunnel configuration

## Post-Installation Steps

1. Change the default admin password:
```bash
argocd account update-password
```