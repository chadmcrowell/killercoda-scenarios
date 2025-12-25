## Step 6: Delete StatefulSet (PVCs remain)

```bash
kubectl delete statefulset web
kubectl get statefulset web 2>&1 || echo "StatefulSet deleted"
kubectl get pods -l app=stateful
kubectl get pvc
```{{exec}}

StatefulSet and pods are gone, but PVCs remain.
