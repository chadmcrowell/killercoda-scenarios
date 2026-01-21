## Step 11: Check routing tables

```bash
# Check if we can access node routing
echo "Checking pod routing (requires node access):"
kubectl run debug-pod --rm -it --image=nicolaka/netshoot --restart=Never -- route -n 2>/dev/null || echo "Route table not accessible from pod"
```{{exec}}

Review pod routing tables when access is available.
