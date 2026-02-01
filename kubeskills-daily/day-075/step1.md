## Step 1: Check if metrics-server is running

```bash
# Check metrics-server
kubectl get deployment -n kube-system metrics-server 2>/dev/null && echo "Metrics-server found" || echo "Metrics-server NOT installed"

# Try to get metrics
kubectl top nodes 2>&1 || echo "Metrics unavailable"
kubectl top pods -A 2>&1 | head -5 || echo "Pod metrics unavailable"
```{{exec}}

Verify if basic metrics collection is available.
