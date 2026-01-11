## Step 3: Check for Pending pods

```bash
# Find Pending pods
kubectl get pods -n capacity-test --field-selector=status.phase=Pending

# Check why Pending
PENDING_POD=$(kubectl get pods -n capacity-test --field-selector=status.phase=Pending -o jsonpath='{.items[0].metadata.name}')

if [ -n "$PENDING_POD" ]; then
  kubectl describe pod -n capacity-test $PENDING_POD | grep -A 10 "Events:"
fi
```

Shows "Insufficient cpu" or "Insufficient memory".
