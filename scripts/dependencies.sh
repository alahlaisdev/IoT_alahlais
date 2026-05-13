#!/bin/bash

# Function to check if a command exists
exists() {
  command -v "$1" >/dev/null 2>&1
}

echo "--- 🛠️  Installing Tools ---"

# 1. Docker
if ! exists docker; then
    echo "🚀 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh && rm get-docker.sh
    sudo usermod -aG docker $USER
    echo "⚠️  Docker installed. You may need to run 'newgrp docker' or re-log."
else
    echo "✅ Docker exists."
fi

# 2. kubectl
if ! exists kubectl; then
    echo "🚀 Installing kubectl..."
    K8S_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
else
    echo "✅ kubectl exists."
fi

# 3. k3d
if ! exists k3d; then
    echo "🚀 Installing k3d..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo "✅ k3d exists."
fi

echo "✨ Environment check complete."