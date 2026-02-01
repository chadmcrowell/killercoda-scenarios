## Step 4: Simulate data loss

```bash
# Delete namespace
kubectl delete namespace backup-test --wait=false &
DELETE_PID=$!

sleep 5

# Check deletion in progress
kubectl get namespace backup-test

wait $DELETE_PID
```{{exec}}

Namespace and all resources deleted, simulating data loss.
