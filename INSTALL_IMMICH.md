# Immich Family Photo Sharing Installation Guide

This guide will help you install Immich for family photo sharing using GitOps best practices with Helm and ArgoCD.

## Prerequisites

1. **Kubernetes Cluster**: Running K3s or similar with ArgoCD installed
2. **PostgreSQL Database**: External PostgreSQL instance (you mentioned you already have this)
3. **Storage**: Longhorn or similar storage class for persistent volumes
4. **Ingress Controller**: Nginx ingress controller
5. **Domain**: Domain name for accessing your family photos

## Quick Start

### 1. Configure Your Environment

Configure your family photo sharing setup:

```bash
./install_immich.sh configure
```

The script will prompt you for:
- PostgreSQL host, port, database name, username, and password
- Domain name for your family photos

### 2. Deploy Immich

```bash
./install_immich.sh deploy
```

### 3. Monitor Deployment

```bash
# Check deployment status
./install_immich.sh status

# Or manually check
kubectl get pods -n immich
kubectl get applications -n argocd
```

## Manual Configuration

If you prefer to configure manually, edit the overlay file:

### Family Photo Sharing Environment
Edit `apps/immich/overlays/dev/kustomization.yaml`:

```yaml
# Update these values in the helmCharts section
externalDatabase:
  host: "your-postgres-host"
  database: "immich"
  username: "immich"
  password: "your-password"
ingress:
  hosts:
    - host: "photos.your-domain.com"
```

## Database Setup

Before deploying, ensure your PostgreSQL database is ready:

```sql
-- Create database and user
CREATE DATABASE immich;
CREATE USER immich WITH PASSWORD 'your-secure-password';
GRANT ALL PRIVILEGES ON DATABASE immich TO immich;
```

## Storage Configuration

For family photo sharing, the configuration includes:
- **Server**: 300Gi storage for uploads, thumbnails, and library files
- **Microservices**: 300Gi storage for processing and temporary files
- **Redis**: 10Gi storage for caching and job queues

This is optimized for family photo collections and can be adjusted if needed.

## Family Photo Sharing Configuration

### Features
- Multiple replicas for reliability
- Balanced resource requirements for smooth photo viewing
- TLS-enabled domain for secure access
- Optimized storage for family photo collections (300Gi)
- Face recognition for organizing family photos

## Accessing Immich

Once deployed, access Immich through:
- **Family Photo Sharing**: `https://photos.your-domain.com`

## Initial Setup

1. **Create Admin User**: Access the web interface and create your first admin user
2. **Configure Mobile App**: Download the Immich mobile app and configure it with your server URL
3. **Upload Photos**: Start uploading your family photo collection
4. **Configure Sharing**: Set up album sharing with family members

## Monitoring and Maintenance

### Health Checks
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

### Resource Usage
```bash
# Check resource usage
kubectl top pods -n immich

# Check storage usage
kubectl get pvc -n immich
```

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Verify PostgreSQL is accessible from the cluster
   - Check database credentials in the overlay configuration
   - Ensure database and user exist

2. **Storage Issues**
   - Verify storage class exists: `kubectl get storageclass`
   - Check available storage capacity
   - Ensure persistent volumes can be created

3. **Ingress Issues**
   - Verify ingress controller is running
   - Check domain DNS configuration
   - Verify TLS certificates (production)

4. **Resource Issues**
   - Monitor resource usage: `kubectl top pods -n immich`
   - Adjust resource limits in overlay configuration if needed

### Performance Optimization

For family photo sharing:
- Monitor storage I/O performance for smooth photo viewing
- Consider SSD storage for better performance
- Adjust Redis memory based on cache requirements
- Optimize machine learning for face recognition

## Security Considerations

1. **Database Security**
   - Use strong passwords
   - Implement network policies to restrict access
   - Regular database backups

2. **Network Security**
   - Use TLS in production
   - Implement network policies
   - Restrict pod communication

3. **Secret Management**
   - Use external secret management (External Secrets Operator, Sealed Secrets)
   - Never commit secrets to Git
   - Rotate secrets regularly

## Updates

To update Immich:

1. Update the Helm chart version in the overlay `kustomization.yaml`
2. Commit and push changes
3. ArgoCD will automatically sync the new version

## Backup Strategy

1. **Database**: Regular PostgreSQL backups
2. **Storage**: Backup persistent volumes
3. **Configuration**: GitOps repository serves as configuration backup
4. **Photos**: Consider additional backup strategy for your photo library

## Support

- **Immich Documentation**: https://immich.app/docs
- **Immich GitHub**: https://github.com/immich-app/immich
- **ArgoCD Documentation**: https://argo-cd.readthedocs.io/

## Next Steps

After successful deployment:

1. **Configure Mobile Apps**: Set up photo sharing with family members
2. **Import Existing Photos**: Upload your family photo collection
3. **Configure Face Recognition**: Train the AI for family face detection
4. **Set Up Sharing**: Configure album sharing with family members
5. **Monitor Performance**: Set up monitoring for smooth photo viewing
6. **Regular Maintenance**: Schedule regular backups and updates 