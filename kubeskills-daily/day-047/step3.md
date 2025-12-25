## Step 3: Scale down (PVCs remain)

```bash
kubectl scale statefulset web --replicas=1
kubectl get pods -l app=stateful
kubectl get pvc
```{{exec}}

Only web-0 runs, but all three PVCs remain.
