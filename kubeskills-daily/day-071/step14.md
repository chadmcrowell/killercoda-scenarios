## Step 14: Test CRD deletion with existing CRs

```bash
# Create CR
cat <<EOF | kubectl apply -f -
apiVersion: example.com/v1
kind: WebApp
metadata:
  name: test-deletion
spec:
  replicas: 1
  image: nginx
EOF

# Try to delete CRD (blocked while CRs exist)
kubectl delete crd webapps.example.com &
CRD_DELETE_PID=$!

sleep 5

# CRD stuck in Terminating
kubectl get crd webapps.example.com

# Kill background process
kill $CRD_DELETE_PID 2>/dev/null

# Delete CRs first
kubectl delete webapp --all

# Now CRD can be deleted
kubectl delete crd webapps.example.com
```{{exec}}

CRD deletion is blocked until all custom resources are deleted first.
