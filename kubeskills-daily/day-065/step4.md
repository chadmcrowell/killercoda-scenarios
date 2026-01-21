## Step 4: Test private registry without credentials

```bash
# Try to pull from private registry (will fail)
kubectl run private-image --image=private-registry.example.com/myapp:v1.0

sleep 10
kubectl describe pod private-image | grep -A 5 "Events:"
```{{exec}}

Expect unauthorized or authentication required errors.
