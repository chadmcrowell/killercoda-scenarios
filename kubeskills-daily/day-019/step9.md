## Step 9: Legacy token secret (deprecated)

```bash
kubectl get sa default -o yaml | grep secrets -A 5
```{{exec}}

Kubernetes 1.24+ stops auto-creating long-lived token secrets; older clusters may show them.
