## Step 10: Check for removed feature gates

```bash
kubectl get --raw /metrics | grep feature_enabled || echo "Metrics not available"
# Watch for removed gates like PodSecurityPolicy (gone in 1.25)
```

Feature gates change between releases; verify what's enabled.
