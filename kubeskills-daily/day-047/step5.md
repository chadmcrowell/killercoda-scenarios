## Step 5: Delete a pod (PVC remains)

```bash
kubectl delete pod web-2
kubectl get pvc
```{{exec}}

Pod is recreated and PVC data-web-2 persists.
