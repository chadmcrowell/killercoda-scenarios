## Step 7: Check PriorityLevelConfigurations

```bash
kubectl get prioritylevelconfigurations
kubectl get prioritylevelconfiguration workload-high -o yaml
```{{exec}}

Inspect nominalConcurrencyShares and limitResponse (Queue vs Reject).
