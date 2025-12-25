## Step 15: Monitor PVC usage and cleanup

```bash
kubectl get pv -o custom-columns=NAME:.metadata.name,CLAIM:.spec.claimRef.name,RECLAIM:.spec.persistentVolumeReclaimPolicy,STATUS:.status.phase

kubectl delete statefulset --all
kubectl delete service stateful-svc 2>/dev/null
kubectl get pvc
kubectl delete pvc --all
kubectl get pv
rm -f /tmp/find-orphan-pvcs.sh
```{{exec}}

Reclaim storage by deleting remaining PVCs and removing the helper script.
