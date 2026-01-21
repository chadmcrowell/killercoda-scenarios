## Step 3: Check init container logs

```bash
# Logs from failed init container
kubectl logs init-fail -c init-1

# Can't get logs from init-2 (never ran)
kubectl logs init-fail -c init-2 2>&1 || echo "Init-2 never started"
```{{exec}}

Inspect logs from the failing init container.
