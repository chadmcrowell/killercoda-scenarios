## Step 15: Clean up ephemeral containers

```bash
kubectl delete pod minimal-app crashloop
kubectl delete pod minimal-app-debug minimal-debug-2 crashloop-debug 2>/dev/null || true
```{{exec}}

Ephemeral containers are removed when the pod is deleted; delete any debug copies too.
