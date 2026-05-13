# --- Configuration ---
NEW_PASSWORD="MyNewSecurePassword123"
ARGOCD_SERVER="localhost:8000"

# 1. Install ArgoCD CLI if missing
if ! command -v argocd >/dev/null 2>&1; then
    echo "🚀 Installing ArgoCD CLI..."
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 0755 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64
fi

# 2. Get the temporary initial password
echo "🔑 Fetching initial admin password..."
INITIAL_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# 3. Login and Update Password
# Note: --insecure is used because ArgoCD uses self-signed certs by default
echo "🔄 Updating admin password..."
argocd login $ARGOCD_SERVER --username admin --password "$INITIAL_PWD" --insecure

argocd account update-password \
  --current-password "$INITIAL_PWD" \
  --new-password "$NEW_PASSWORD"

echo "------------------------------------------------"
echo "✅ Password successfully changed!"
echo "👤 Username: admin"
echo "🔐 Password: $NEW_PASSWORD"
echo "------------------------------------------------"