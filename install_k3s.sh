
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install k3s with Traefik ingress controller (default)
curl -sfL https://get.k3s.io | sh -

# Wait for k3s to be ready
sudo systemctl status k3s

# Set up kubeconfig for your user (optional, for easier kubectl access)
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
export KUBECONFIG=~/.kube/config

# Verify installation
kubectl get nodes
kubectl get pods -A

# Check that Traefik ingress controller is running
kubectl get pods -n kube-system | grep traefik
