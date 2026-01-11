## Step 11: Check node taints and tolerations

```bash
# Check node taints
kubectl describe nodes | grep "Taints:"

# Pods without matching tolerations can't schedule on tainted nodes
```

Taints can reduce schedulable capacity when not tolerated.
