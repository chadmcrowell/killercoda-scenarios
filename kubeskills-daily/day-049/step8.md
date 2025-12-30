## Step 8: Restore from backup

```bash
velero restore create restore-test-1 \
  --from-backup backup-test-ns \
  --wait

velero restore describe restore-test-1
```{{exec}}

```bash
kubectl get all -n backup-test
kubectl get configmap -n backup-test
kubectl get secret -n backup-test
```{{exec}}

Restore the namespace and inspect resources.
