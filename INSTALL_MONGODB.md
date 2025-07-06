# MongoDB Installation Guide

This guide documents the installation and configuration of MongoDB in our Kubernetes cluster using GitOps principles.

## Prerequisites

- Kubernetes cluster (k3s)
- kubectl configured to access the cluster
- ArgoCD installed and configured
- local-path storage class available

## Installation Steps

1. The MongoDB manifests are already prepared in `apps/mongodb/base/`

2. Apply the MongoDB configuration using ArgoCD:
```bash
kubectl apply -f apps/mongodb/base/argocd-app.yaml
```

3. Or apply directly using kustomize:
```bash
kubectl apply -k apps/mongodb/base/
```

4. Wait for all pods to be ready:
```bash
kubectl get pods -n mongodb -w
```

5. Check the MongoDB service:
```bash
kubectl get svc -n mongodb
```

## Configuration Details

The installation includes:
- MongoDB 7.0 running in standalone mode
- Persistent storage using local-path provisioner (10Gi)
- Authentication enabled with root user
- Application user and database created automatically
- Health checks and resource limits configured
- Ingress configured for external access (optional)

## Default Credentials

**Root User:**
- Username: `mongodb`
- Password: `MongoDB123!`
- Database: `admin`

**Application User:**
- Username: `mongodb`
- Password: `MongoDB123!`
- Database: `appdb`

## Connection Details

**Internal Connection (from within the cluster):**
- Host: `mongodb.mongodb.svc.cluster.local`
- Port: `27017`
- Connection String: `mongodb://mongodb:MongoDB123!@mongodb.mongodb.svc.cluster.local:27017/appdb`

**External Connection (if ingress is enabled):**
- Host: `mongodb.elladali.com`
- Port: `27017`

## Security Notes

⚠️ **Important:** The default passwords in this configuration are for demonstration purposes only. In production:

1. Generate secure random passwords
2. Use Kubernetes secrets or external secret management
3. Consider using MongoDB Atlas or a managed MongoDB service
4. Enable TLS encryption for connections
5. Restrict network access using NetworkPolicies

## Troubleshooting

If you encounter any issues:

1. Check pod status: `kubectl get pods -n mongodb`
2. Check pod logs: `kubectl logs -n mongodb <pod-name>`
3. Check the init job logs: `kubectl logs -n mongodb job/mongodb-init`
4. Verify PVC creation: `kubectl get pvc -n mongodb`
5. Check service connectivity: `kubectl get svc -n mongodb`

## Post-Installation Steps

1. Change the default passwords:
```bash
# Connect to MongoDB and change passwords
kubectl exec -it -n mongodb deployment/mongodb -- mongosh --username mongodb --password MongoDB123! --authenticationDatabase admin
```

2. Create additional databases and users as needed
3. Configure backup strategies
4. Set up monitoring and alerting

## Resource Requirements

- Memory: 512Mi (request) / 1Gi (limit)
- CPU: 250m (request) / 500m (limit)
- Storage: 10Gi persistent volume

## Scaling

To scale MongoDB horizontally, consider:
- Using MongoDB Replica Set instead of standalone
- Implementing MongoDB Sharding for large datasets
- Using MongoDB Atlas for managed scaling 