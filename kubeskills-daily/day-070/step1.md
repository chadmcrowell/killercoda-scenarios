## Step 1: Check if metrics-server is installed

```bash
# Check for metrics-server
kubectl get deployment -n kube-system metrics-server 2>/dev/null && echo "Metrics-server installed" || echo "Metrics-server NOT installed"

# Try to get pod metrics
kubectl top pods 2>&1 || echo "Metrics not available"

# Try to get node metrics
kubectl top nodes 2>&1 || echo "Node metrics not available"
```{{exec}}

Verify whether metrics are available for autoscaling.
