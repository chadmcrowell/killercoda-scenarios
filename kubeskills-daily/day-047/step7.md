## Step 7: Manually clean up orphaned PVCs

```bash
kubectl delete pvc data-web-0 data-web-1 data-web-2
kubectl get pvc
kubectl get pv
```{{exec}}

PVCs must be deleted manually to reclaim storage.
