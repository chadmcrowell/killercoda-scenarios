## Step 14: Debug RBAC with auth can-i

```bash
kubectl auth can-i create deployments --as=system:serviceaccount:rbac-test:restricted-sa -n rbac-test
```{{exec}}

```bash
kubectl auth can-i --list --as=system:serviceaccount:rbac-test:restricted-sa -n rbac-test
```{{exec}}

```bash
kubectl exec -n rbac-test kubectl-pod -- kubectl auth can-i create pods -n rbac-test
```{{exec}}

Use `auth can-i` to verify permissions both from the control plane and inside the pod.
