## Step 15: Debug stuck init containers

```bash
# Find pods stuck in Init
kubectl get pods --all-namespaces --field-selector=status.phase=Pending | grep Init || true

# Check which init container is stuck
kubectl get pod init-fail -o jsonpath='{.status.initContainerStatuses[*].name}'; echo ""

# Check init container state
kubectl get pod init-fail -o jsonpath='{.status.initContainerStatuses[*].state}'; echo ""

# Get logs from specific init container
kubectl logs init-fail -c failing-init
```{{exec}}

Use jsonpath to see which init container is blocked, then grab its logs for root-cause.
