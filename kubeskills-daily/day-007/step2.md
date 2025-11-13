## Step 2: Check init-container logs

```bash
kubectl logs blocked-pod -c wait-for-db
```{{exec}}

Endless `waiting` messages prove the init container is stuck, so the main nginx container never starts.
