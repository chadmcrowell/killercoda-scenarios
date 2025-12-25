## Step 15: Debug performance with metrics

```bash
kubectl top pods -A --sort-by=cpu
kubectl top pods -A --sort-by=memory
kubectl describe nodes | grep -A 5 "Allocated resources"
kubectl get pods -A -o json | jq -r '
  .items[] |
  select(.spec.containers[].resources.limits.cpu != null) |
  "\(.metadata.namespace)/\(.metadata.name)"
'
```{{exec}}

Find the noisiest pods, node pressure, and pods hitting CPU limits.
