## Step 4: Try to create a pod (will timeout!)

```bash
# This will hang for 10 seconds then fail
kubectl run timeout-test --image=nginx --timeout=15s 2>&1 || echo "Webhook timeout!"

# Check error
kubectl get events --sort-by='.lastTimestamp' | grep -i webhook | tail -5
```{{exec}}

Observe the timeout and the event indicating a failed webhook call.
