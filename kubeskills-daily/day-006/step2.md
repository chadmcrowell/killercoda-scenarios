## Step 2: Watch the restart loop

```bash
kubectl get pods slow-app -w
```{{exec}}

Observe Running → Running (failing) → Restart → CrashLoopBackOff.
