
# dependencies

# install docker and k3d if not exist

# create a cluster

# add argocd

# install argocd client cli

# output the argocd username and password to login in the web

# set the git repo (the source of truth)



#!/bin/bash

CLUSTER_NAME="my-argo-cluster"

# 1. Create k3d cluster
# We expose port 80 and 443 to the host to access services later
if k3d cluster list | grep -q "$CLUSTER_NAME"; then
    echo "✅ Cluster '$CLUSTER_NAME' already exists."
else
    echo "🚀 Creating k3d cluster..."
    k3d cluster create $CLUSTER_NAME --api-port 6550 -p "8000:30080@loadbalancer"
fi


# 2. Install ArgoCD
echo "📂 Installing ArgoCD..."
kubectl create namespace argocd
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort", "ports": [{"port": 80, "nodePort": 30080}]}}'




kubectl create namespace dev


