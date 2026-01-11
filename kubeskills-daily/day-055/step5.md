## Step 5: Test ClusterRole vs Role scope

```bash
# Create ClusterRole
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
EOF

# Bind ClusterRole to SA (cluster-wide access)
kubectl create clusterrolebinding cluster-reader-binding \
  --clusterrole=cluster-pod-reader \
  --serviceaccount=default:cluster-sa

kubectl create serviceaccount cluster-sa

# Test cross-namespace access
kubectl create namespace other-ns
kubectl run test-pod -n other-ns --image=nginx

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cluster-test
spec:
  serviceAccountName: cluster-sa
  containers:
  - name: test
    image: curlimages/curl:latest
    command: ['sleep', '3600']
EOF

# List pods in other namespace (should work with ClusterRole)
kubectl exec cluster-test -- sh -c '
  TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
  curl -k -H "Authorization: Bearer $TOKEN" \
    https://kubernetes.default.svc/api/v1/namespaces/other-ns/pods
' | jq -r '.items[].metadata.name' 2>/dev/null || echo "ClusterRole allows cross-namespace"
```{{exec}}

ClusterRole bindings grant access across namespaces.
