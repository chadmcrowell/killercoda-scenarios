## Step 2: Access ArgoCD UI (port-forward)

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &

# Get admin password
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD Password: $ARGOCD_PASSWORD"
```

**Login with CLI:**
```bash
# Install ArgoCD CLI
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

argocd login localhost:8080 --username admin --password $ARGOCD_PASSWORD --insecure
```{{exec}}

Port-forward exposes the UI; CLI login uses the initial admin secret.
