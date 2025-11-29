## Step 2: Deploy a pod using this ServiceAccount (with kubectl)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: kubectl-pod
  namespace: rbac-test
spec:
  serviceAccountName: restricted-sa
  containers:
  - name: kubectl
    image: bitnami/kubectl:latest
    command: ['sleep', '3600']
EOF
```{{exec}}

```bash
kubectl get pod kubectl-pod -n rbac-test
```{{exec}}

Pod runs kubectl but inherits the restricted ServiceAccount.
