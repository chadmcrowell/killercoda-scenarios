## Step 4: View resource usage before termination

```bash
kubectl top pod memory-hog
```{{exec}}

You might see an error if the pod is restarting—yet another sign that the OOM event happened quickly.
