## Step 4: Debug with different image

```bash
kubectl debug minimal-app -it --image=nicolaka/netshoot --target=app
```{{exec}}

Use netshoot tools (curl, dig, traceroute, netstat) to inspect networking.
