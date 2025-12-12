## Step 4: Create ArgoCD Application

```bash
cat <<'APP' | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: /tmp/gitops-repo
    targetRevision: HEAD
    path: .
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: false
      selfHeal: false
APP
```{{exec}}

Creates an Application pointing to the local repo. In production use a real Git URL.
