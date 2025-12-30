## Step 15: Check priority levels

```bash
kubectl get prioritylevelconfiguration -o custom-columns=NAME:.metadata.name,SHARES:.spec.limited.nominalConcurrencyShares,QUEUES:.spec.limited.limitResponse.queuing.queues
kubectl describe prioritylevelconfiguration system
kubectl describe prioritylevelconfiguration workload-high
```{{exec}}

Compare system vs user workload priorities and concurrency shares.
