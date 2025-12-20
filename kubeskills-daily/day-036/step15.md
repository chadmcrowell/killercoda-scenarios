## Step 15: Debug failed Job

```bash
# Get failed pods
kubectl get pods -l job-name=failing-job --field-selector=status.phase=Failed

# Check logs from failed pod
FAILED_POD=$(kubectl get pods -l job-name=failing-job --field-selector=status.phase=Failed -o jsonpath='{.items[0].metadata.name}')
kubectl logs $FAILED_POD

# Check exit code
kubectl get pod $FAILED_POD -o jsonpath='{.status.containerStatuses[0].state.terminated.exitCode}'; echo ""

# Get reason
kubectl get pod $FAILED_POD -o jsonpath='{.status.containerStatuses[0].state.terminated.reason}'; echo ""
```{{exec}}

Use events, logs, and container status to find why the Job failed.
