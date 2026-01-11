## Step 14: Test audit mode

```bash
# Check audit logs (if accessible)
kubectl get events -n warn-ns --sort-by='.lastTimestamp' | grep -i "audit"

# Or check API server logs
# kubectl logs -n kube-system -l component=kube-apiserver --tail=50 | grep audit
```{{exec}}

Audit mode logs violations without blocking.
