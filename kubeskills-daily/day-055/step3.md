## Step 3: Test missing list permission

```bash
# Create pod with limited SA
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: limited-pod
spec:
  serviceAccountName: limited-sa
  containers:
  - name: test
    image: curlimages/curl:latest
    command: ['sleep', '3600']
EOF

# Try to list pods (should fail)
kubectl exec limited-pod -- sh -c '
  TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
  curl -k -H "Authorization: Bearer $TOKEN" \
    https://kubernetes.default.svc/api/v1/namespaces/default/pods
' 2>&1 | grep -i "forbidden"

# Try to get specific pod (should work)
kubectl exec limited-pod -- sh -c '
  TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
  curl -k -H "Authorization: Bearer $TOKEN" \
    https://kubernetes.default.svc/api/v1/namespaces/default/pods/limited-pod
' | jq .metadata.name 2>/dev/null || echo "Get succeeded"
```{{exec}}

Demonstrate that get is not the same as list in RBAC.
