## Step 12: Check controller metrics and health

```bash
# Check reconciliation rate
kubectl logs -l app=broken-controller --tail=100 | grep "Reconciling" | wc -l

# Check API request rate
kubectl get --raw /metrics | grep apiserver_request_total | grep example.com

# Check controller resource usage
kubectl top pod -l app=broken-controller
```{{exec}}

Measure the impact of bad reconciliation patterns.
