## Step 9: Check for incomplete restore

```bash
POD=$(kubectl get pods -n backup-test -l app=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n backup-test $POD -- cat /usr/share/nginx/html/index.html 2>&1 || echo "Data NOT restored (emptyDir)"

kubectl get pod pvc-pod -n backup-test
kubectl exec -n backup-test pvc-pod -- cat /data/file.txt 2>&1 || echo "PVC data lost (no snapshot)"
```{{exec}}

emptyDir and PVC data are missing because snapshots were not taken.
