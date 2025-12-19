## Step 4: Check init container logs

```bash
kubectl logs -l app=service-a -c wait-for-service-b
kubectl logs -l app=service-b -c wait-for-service-a
```{{exec}}

Each init container endlessly waits on the other service.
