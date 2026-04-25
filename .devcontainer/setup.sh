#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Kind..."
KIND_VERSION="v0.23.0"
curl -Lo /usr/local/bin/kind \
  "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"
chmod +x /usr/local/bin/kind

echo "==> Installing kagent CLI..."
curl -sSL https://raw.githubusercontent.com/kagent-dev/kagent/main/scripts/install.sh | bash

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
