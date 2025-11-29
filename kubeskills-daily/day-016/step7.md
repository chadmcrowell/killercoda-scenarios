## Step 7: Test again (success!)

```bash
kubectl exec -n rbac-test kubectl-pod -- kubectl get pods -n rbac-test
```{{exec}}

Listing pods now works inside the namespace.

```bash
kubectl exec -n rbac-test kubectl-pod -- kubectl get pods -n default
```{{exec}}

Still forbidden in other namespaces—Role is namespace-scoped.
