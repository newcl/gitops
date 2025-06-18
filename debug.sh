#!/bin/bash

set -e

echo "==[ Argo CD Pod Status ]=="
kubectl -n argocd get pods -l app.kubernetes.io/name=argocd-server

echo -e "\n==[ Argo CD Server Logs (last 20 lines) ]=="
kubectl -n argocd logs -l app.kubernetes.io/name=argocd-server --tail=20

echo -e "\n==[ Argo CD Service ]=="
kubectl -n argocd get svc argocd-server -o wide

echo -e "\n==[ Argo CD Endpoints ]=="
kubectl -n argocd get endpoints argocd-server -o yaml

echo -e "\n==[ Ingress Definition ]=="
kubectl -n argocd get ingress argocd-server-ingress -o yaml

echo -e "\n==[ Traefik Logs (last 30 lines) ]=="
kubectl -n kube-system logs -l app.kubernetes.io/name=traefik --tail=30

echo -e "\n==[ Checking if Traefik picked up the Ingress ]=="
kubectl -n kube-system exec -it $(kubectl -n kube-system get pods -l app.kubernetes.io/name=traefik -o jsonpath="{.items[0].metadata.name}") -- traefik version || true

echo -e "\n==[ Check curl from inside the cluster ]=="
kubectl run test-curl --rm -i --tty --image=curlimages/curl --restart=Never -- curl -v http://argocd-server.argocd.svc.cluster.local:80

echo -e "\n==[ Done. Review any errors above. ]=="

