## Step 3: Inspect events and restart count

```bash
kubectl describe pod slow-app | grep -A 10 Events
```{{exec}}

```bash
kubectl get pod slow-app
```{{exec}}

Look for `Liveness probe failed: Get ... context deadline exceeded` and watch the RESTARTS column climb.
