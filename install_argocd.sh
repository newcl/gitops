kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f - && \
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml && \
kubectl apply -f clusters/dev/argocd.yaml
