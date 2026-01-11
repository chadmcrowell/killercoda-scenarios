## Step 4: Test operator without required permissions

```bash
# Create a simple operator ServiceAccount
kubectl create serviceaccount operator-sa

# Create Role WITHOUT 'create' permission
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: broken-operator-role
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list", "watch"]  # Missing 'create', 'update', 'delete'
EOF

kubectl create rolebinding broken-operator-binding \
  --role=broken-operator-role \
  --serviceaccount=default:operator-sa

# Deploy operator pod
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: broken-operator
spec:
  serviceAccountName: operator-sa
  containers:
  - name: operator
    image: curlimages/curl:latest
    command: ['sh', '-c']
    args:
    - |
      while true; do
        TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
        echo "Attempting to create ConfigMap..."
        curl -k -X POST \
          -H "Authorization: Bearer $TOKEN" \
          -H "Content-Type: application/json" \
          https://kubernetes.default.svc/api/v1/namespaces/default/configmaps \
          -d '{"metadata":{"name":"test-cm"},"data":{"key":"value"}}' 2>&1 | grep -o "forbidden"
        sleep 10
      done
EOF

# Check logs - operator fails to create resources
sleep 15
kubectl logs broken-operator --tail=5
```{{exec}}

Watch a looped operator fail because it lacks create permissions.
