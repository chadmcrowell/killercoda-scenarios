## Step 7: Simulate disaster (delete namespace)

```bash
kubectl delete namespace backup-test
kubectl get namespace backup-test 2>&1 || echo "Namespace deleted"
kubectl get pods -n backup-test 2>&1 || echo "Pods gone"
```{{exec}}

Namespace and workloads are removed.
