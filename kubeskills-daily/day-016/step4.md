## Step 4: Check what permissions the SA has

```bash
kubectl auth can-i list pods --as=system:serviceaccount:rbac-test:restricted-sa -n rbac-test
```{{exec}}

```bash
kubectl auth can-i --list --as=system:serviceaccount:rbac-test:restricted-sa -n rbac-test
```{{exec}}

Output should be `no` and minimal permissions (self-subject access review only).
