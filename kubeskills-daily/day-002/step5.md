## Step 5: Verify `web-2` eventually starts

Once `web-1` is healthy again, restart your watch or list pods to confirm all three are Running:

```bash
kubectl get pods -l app=nginx
```{{exec}}

The final state should show `web-0`, `web-1`, and `web-2` all Running.
