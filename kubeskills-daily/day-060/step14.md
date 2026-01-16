## Step 14: Compare controller behavior

```bash
echo "=== Controller Comparison ==="

echo -e "\nBroken Controller (no status update):"
kubectl logs -l app=broken-controller --tail=5

echo -e "\nWorking Controller (with status update):"
kubectl logs -l app=working-controller --tail=5

echo -e "\nAPI Request Rates:"
kubectl get --raw /metrics | grep "apiserver_request_total.*example.com" | grep -v "#"
```{{exec}}

Compare noisy reconciliation versus steady-state behavior.
