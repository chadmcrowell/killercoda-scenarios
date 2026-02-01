## Step 10: Test namespace stuck in Terminating

```bash
# Create namespace with finalizer
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: stuck-namespace
  finalizers:
  - kubernetes.io/some-finalizer
EOF

# Create resources
kubectl create deployment test -n stuck-namespace --image=nginx

# Try to delete namespace
kubectl delete namespace stuck-namespace &
NS_DELETE_PID=$!

sleep 10

# Check status (stuck)
kubectl get namespace stuck-namespace

# Kill background process
kill $NS_DELETE_PID 2>/dev/null

# Force delete namespace
kubectl get namespace stuck-namespace -o json | \
  jq '.spec.finalizers = []' | \
  kubectl replace --raw /api/v1/namespaces/stuck-namespace/finalize -f -

# Now it deletes
kubectl get namespace stuck-namespace 2>&1 || echo "Namespace deleted"
```{{exec}}

Namespace stuck in Terminating state due to finalizers.
