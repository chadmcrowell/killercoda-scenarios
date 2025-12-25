## Step 1: Check default container logging

```bash
kubectl run logger --image=busybox --restart=Never -- sh -c 'while true; do echo "Log line $(date)"; sleep 1; done'

kubectl logs logger --tail=10
```{{exec}}

Logs are accessible via `kubectl logs`, stored on the node.
