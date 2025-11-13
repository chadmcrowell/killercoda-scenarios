## Step 3: Inspect the termination reason

```bash
kubectl describe pod memory-hog | grep -A 5 "Last State"
```{{exec}}

Expect `Reason: OOMKilled` and `Exit Code: 137` (128 + 9 for SIGKILL).
