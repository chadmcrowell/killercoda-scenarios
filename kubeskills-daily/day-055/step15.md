## Step 15: Create least-privilege role

```bash
# Example: CI/CD deployer role
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: deployer
  namespace: default
rules:
# Deployments
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
- apiGroups: ["apps"]
  resources: ["deployments/status"]
  verbs: ["get"]
# Services
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get", "list", "create", "update", "patch"]
# ConfigMaps (read-only)
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list"]
# Secrets (read-only)
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get"]
# Events (for logs)
- apiGroups: [""]
  resources: ["events"]
  verbs: ["get", "list"]
# Pod logs
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get"]
EOF

kubectl create serviceaccount deployer-sa
kubectl create rolebinding deployer-binding \
  --role=deployer \
  --serviceaccount=default:deployer-sa

# Verify permissions
echo "Deployer can:"
kubectl auth can-i create deployments --as=system:serviceaccount:default:deployer-sa && echo "  ✓ Create deployments"
kubectl auth can-i delete secrets --as=system:serviceaccount:default:deployer-sa || echo "  ✗ Delete secrets (good!)"
```{{exec}}

Build a least-privilege role for common CI/CD tasks.
