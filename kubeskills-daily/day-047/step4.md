## Step 4: Scale back up (reattaches PVCs)

```bash
kubectl scale statefulset web --replicas=3
kubectl wait --for=condition=Ready pods -l app=stateful --timeout=60s
kubectl exec web-1 -- cat /usr/share/nginx/html/index.html
kubectl exec web-2 -- cat /usr/share/nginx/html/index.html
```{{exec}}

Scaling up reuses existing PVCs with their data intact.
