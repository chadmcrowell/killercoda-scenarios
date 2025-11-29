## Step 3: Try to list pods (fails!)

```bash
kubectl exec -n rbac-test kubectl-pod -- kubectl get pods
```{{exec}}

Expect Forbidden: the ServiceAccount cannot list pods yet.
