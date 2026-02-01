## Step 13: Test namespace deletion cascade

```bash
# Create test namespace with resources
kubectl create namespace delete-test
kubectl create deployment test -n delete-test --image=nginx
kubectl create configmap test-cm -n delete-test --from-literal=key=value

# Delete namespace (cascades to all resources)
kubectl delete namespace delete-test &
DELETE_PID=$!

sleep 5

# Check deletion in progress
kubectl get namespace delete-test
kubectl get all -n delete-test 2>&1 || echo "Resources being deleted"

wait $DELETE_PID
```{{exec}}

Namespace deletion cascades to all contained resources.
