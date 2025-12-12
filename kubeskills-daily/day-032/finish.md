<br>

### ArgoCD drift controlled

**Key observations**

✅ OutOfSync signals Git vs cluster drift; auto-sync/self-heal fix it automatically.  
✅ Hooks and waves orchestrate ordering; failed PreSync blocks deployment.  
✅ Prune deletes stray resources; replace strategy forces recreate.  
✅ Selective sync, history, and rollback keep changes safe and auditable.

**Production patterns**

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: production-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/org/repo
    targetRevision: main
    path: apps/production
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - PruneLast=true
```

**Cleanup**

```bash
pkill -f "port-forward.*argocd"
kubectl delete namespace argocd
rm -rf /tmp/gitops-repo
```{{exec}}

---

Next: Day 33 - Service Mesh Traffic Routing Failures
