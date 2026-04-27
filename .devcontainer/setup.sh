#!/usr/bin/env bash
set -euo pipefail

echo "==> Ensuring Docker is ready..."
until docker info >/dev/null 2>&1; do
  echo "Waiting for Docker daemon..."
  sleep 2
done

echo "==> Installing dependencies (Ubuntu)..."
sudo apt-get update && sudo apt-get install -y openssl curl

echo "==> Installing Kind..."
KIND_VERSION="v0.23.0"
if ! command -v kind &> /dev/null; then
    sudo curl -Lo /usr/local/bin/kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"
    sudo chmod +x /usr/local/bin/kind
fi

echo "==> Installing kagent CLI..."
sudo curl https://raw.githubusercontent.com/kagent-dev/kagent/refs/heads/main/scripts/get-kagent | bash 

echo "==> Creating Kind cluster..."
cat <<EOF | kind create cluster --name lab --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
EOF

echo "==> Verifying cluster..."
kubectl get nodes

echo "==> Setup complete. Run 'kubectl get nodes' to confirm your cluster is ready."
