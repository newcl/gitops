# ArgoCD GitOps Repository

This repository contains the GitOps configurations for managing Kubernetes deployments using ArgoCD.

## Repository Structure

```
.
├── apps/                    # Application definitions
│   ├── argocd/             # ArgoCD installation and configuration
│   │   ├── base/           # Base ArgoCD installation
│   │   └── overlays/       # Environment-specific ArgoCD configs
│   │       ├── dev/        # Development environment
│   │       ├── staging/    # Staging environment
│   │       └── prod/       # Production environment
│   ├── base/               # Base application configurations
│   └── overlays/           # Environment-specific overlays
│       ├── dev/            # Development environment
│       ├── staging/        # Staging environment
│       └── prod/           # Production environment
├── clusters/               # Cluster-specific configurations
│   ├── dev/               # Development cluster configs
│   ├── staging/           # Staging cluster configs
│   └── prod/              # Production cluster configs
└── components/             # Reusable Kubernetes components
    ├── deployments/       # Deployment manifests
    ├── services/         # Service manifests
    └── configmaps/       # ConfigMap manifests
```

## Directory Purpose

### apps/
- Contains ArgoCD Application definitions
- `argocd/`: Contains ArgoCD's own installation and configuration
  - `base/`: Base ArgoCD installation using official manifests
  - `overlays/`: Environment-specific ArgoCD configurations
- `base/`: Base application configurations that are common across environments
- `overlays/`: Environment-specific customizations using Kustomize

### clusters/
- Contains cluster-specific configurations
- Each environment (dev/staging/prod) has its own directory
- Includes cluster-specific resources like namespaces, RBAC, etc.

### components/
- Reusable Kubernetes manifests
- Organized by resource type (deployments, services, configmaps)
- These components are referenced by applications in the `apps/` directory

## Best Practices

1. **Environment Separation**: Keep environment-specific configurations in separate directories
2. **DRY (Don't Repeat Yourself)**: Use Kustomize to manage environment-specific variations
3. **Version Control**: All changes should be made through Git
4. **Security**: Sensitive data should be managed using sealed secrets or external secret management
5. **Documentation**: Keep README files updated in each directory

## Getting Started

1. Install ArgoCD using the provided configuration:
   ```bash
   # For dev environment
   kubectl apply -k apps/argocd/overlays/dev
   ```

2. Add your application manifests to the appropriate directories
3. Create ArgoCD Application definitions in the `apps/` directory
4. Configure environment-specific overlays using Kustomize
5. Commit and push changes to trigger ArgoCD sync 