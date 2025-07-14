# Immich Family Photo Sharing Application

This directory contains the GitOps configuration for deploying Immich, a self-hosted photo and video sharing solution for families, using Helm charts and ArgoCD.

## Overview

Immich is a high-performance self-hosted photo and video sharing solution that provides:
- Easy photo/video sharing with family members
- Face recognition for organizing family photos
- Album creation and sharing
- Web interface for browsing and managing photos
- Mobile apps for easy access and uploads

## Architecture

The application consists of several microservices:
- **Server**: Main API server handling requests
- **Microservices**: Background job processing
- **Machine Learning**: Face recognition and object detection
- **Web**: Frontend web interface
- **Redis**: Caching and job queue
- **PostgreSQL**: External database (not included in this deployment)

## Directory Structure

```
apps/immich/
├── base/                    # Base configuration
│   ├── namespace.yaml      # Kubernetes namespace
│   ├── kustomization.yaml  # Kustomize configuration
│   ├── values.yaml         # Helm values (reference)
│   └── argocd-app.yaml     # ArgoCD application definition
├── overlays/               # Environment-specific configurations
│   └── dev/               # Family photo sharing environment
└── README.md              # This file
```

## Prerequisites

1. **PostgreSQL Database**: External PostgreSQL instance must be available
2. **Kubernetes Cluster**: Running K3s or similar with ArgoCD
3. **Storage**: Longhorn or similar storage class for persistent volumes
4. **Ingress Controller**: Nginx ingress controller
5. **TLS Certificates**: Cert-manager for automatic SSL certificates (production)

## Configuration

### Database Setup

Before deploying, ensure your PostgreSQL database is ready:

```sql
-- Create database and user
CREATE DATABASE immich;
CREATE USER immich WITH PASSWORD 'your-secure-password';
GRANT ALL PRIVILEGES ON DATABASE immich TO immich;
```

### Family Photo Sharing Configuration

The configuration is optimized for family photo sharing:

#### Family Environment (`overlays/dev/`)
- Balanced resources for smooth photo viewing and sharing
- Multiple replicas for reliability
- TLS-enabled domain for secure access
- Optimized storage for family photo collections (300Gi)
- Face recognition for organizing family photos

## Deployment

### 1. Update Configuration

Before deploying, update the following in your environment's `kustomization.yaml`:

- **Database Configuration**:
  - `externalDatabase.host`: Your PostgreSQL host
  - `externalDatabase.password`: Your database password
  - `externalDatabase.database`: Database name

- **Domain Configuration**:
  - `ingress.hosts[0].host`: Your domain name

- **Storage Configuration**:
  - `storageClass`: Your storage class name (default: "longhorn")

### 2. Deploy for Family Photo Sharing

```bash
# Apply the family photo sharing configuration
kubectl apply -k apps/immich/overlays/dev
```

## Accessing Immich

Once deployed, access Immich through:
- **Family Photo Sharing**: `https://photos.your-domain.com`

## Storage Requirements

For family photo sharing, the following storage is configured:

- **Server**: 300Gi (for uploads, thumbnails, and library files)
- **Microservices**: 300Gi (for processing and temporary files)
- **Redis**: 10Gi (for caching and job queues)

## Resource Requirements

### Family Photo Sharing Environment
- **Server**: 2 replicas, 512Mi-1Gi memory, 250m-500m CPU
- **Microservices**: 2 replicas, 512Mi-1Gi memory, 250m-500m CPU
- **Machine Learning**: 1 replica, 1Gi-2Gi memory, 500m-1000m CPU
- **Web**: 2 replicas, 128Mi-256Mi memory, 100m-200m CPU
- **Redis**: 1 replica, 256Mi-512Mi memory, 125m-250m CPU

## Monitoring and Maintenance

### Health Checks

Monitor the application using:

```bash
# Check pod status
kubectl get pods -n immich

# Check services
kubectl get svc -n immich

# Check ingress
kubectl get ingress -n immich
```

### Logs

```bash
# Server logs
kubectl logs -n immich deployment/immich-server

# Microservices logs
kubectl logs -n immich deployment/immich-microservices

# Machine learning logs
kubectl logs -n immich deployment/immich-machine-learning
```

### Backup Strategy

1. **Database**: Regular PostgreSQL backups
2. **Storage**: Backup persistent volumes
3. **Configuration**: GitOps repository serves as configuration backup

## Troubleshooting

### Common Issues

1. **Database Connection**: Ensure PostgreSQL is accessible and credentials are correct
2. **Storage**: Verify storage class exists and has sufficient capacity
3. **Ingress**: Check ingress controller and domain DNS configuration
4. **Resources**: Monitor resource usage and adjust limits if needed

### Performance Optimization

For large photo libraries:
- Increase machine learning replicas for faster processing
- Adjust Redis memory based on cache requirements
- Monitor storage I/O performance
- Consider SSD storage for better performance

## Security Considerations

1. **Database**: Use strong passwords and network policies
2. **TLS**: Enable TLS in production with valid certificates
3. **Network**: Use network policies to restrict pod communication
4. **Secrets**: Store sensitive data in Kubernetes secrets or external secret management

## Updates

To update Immich:

1. Update the Helm chart version in `kustomization.yaml`
2. Commit and push changes
3. ArgoCD will automatically sync the new version

## Support

For issues with Immich itself, refer to the [official documentation](https://immich.app/docs) and [GitHub repository](https://github.com/immich-app/immich). 