## Step 14: Test split-horizon DNS

```bash
# Test that cluster DNS takes precedence
kubectl exec dns-test -- nslookup kubernetes.default

# External domain lookup
kubectl exec dns-test -- nslookup kubernetes.com
```{{exec}}

Compare in-cluster DNS vs external lookups.
