## Step 10: ClusterRoleBinding for cluster-wide access

```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: read-pods-global
subjects:
- kind: ServiceAccount
  name: restricted-sa
  namespace: rbac-test
roleRef:
  kind: ClusterRole
  name: pod-reader-cluster
  apiGroup: rbac.authorization.k8s.io
EOF
```{{exec}}

```bash
kubectl exec -n rbac-test kubectl-pod -- kubectl get pods --all-namespaces
```{{exec}}

ClusterRole + ClusterRoleBinding grants cluster-wide access to pods.
