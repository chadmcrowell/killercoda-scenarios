## Step 2: Diagnose the failure

```bash
kubectl describe pod private-image-fail | grep -A 10 Events
```{{exec}}

Look for "Failed to pull image" messages like unauthorized, DNS failure, or network timeout.
