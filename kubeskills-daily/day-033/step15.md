## Step 15: Check VirtualService status

```bash
kubectl get virtualservice webapp -o yaml
istioctl analyze
```{{exec}}

Check config warnings and status for routing issues.
