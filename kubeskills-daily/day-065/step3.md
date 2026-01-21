## Step 3: Test wrong registry

```bash
kubectl run wrong-registry --image=wrong-registry.example.com/nginx:latest

sleep 10
kubectl describe pod wrong-registry | grep -A 5 "Failed"
```{{exec}}

Verify DNS or connection errors for a bad registry URL.
