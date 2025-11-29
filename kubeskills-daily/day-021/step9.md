## Step 9: Delete pod to allow PVC deletion

```bash
kubectl delete pod pvc-user
```{{exec}}

```bash
kubectl get pvc test-pvc -w
```{{exec}}

Once the pod is gone, the PVC finalizer clears and deletion completes.
