## Step 8: Test other operations (still denied)

```bash
kubectl exec -n rbac-test kubectl-pod -- kubectl delete pod kubectl-pod -n rbac-test
```{{exec}}

Expected error: delete verb not granted.

```bash
kubectl exec -n rbac-test kubectl-pod -- kubectl get services -n rbac-test
```{{exec}}

Services not granted either—Role only covers pods read verbs.
