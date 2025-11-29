## Step 13: Test multiple finalizers

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: multi-finalizer
  finalizers:
  - finalizer1.example.com
  - finalizer2.example.com
  - finalizer3.example.com
data:
  test: data
EOF
```{{exec}}

```bash
kubectl delete configmap multi-finalizer
```{{exec}}

```bash
kubectl patch configmap multi-finalizer -p '{"metadata":{"finalizers":["finalizer2.example.com","finalizer3.example.com"]}}' --type=merge
kubectl get configmap multi-finalizer
kubectl patch configmap multi-finalizer -p '{"metadata":{"finalizers":[]}}' --type=merge
```{{exec}}

All finalizers must be removed before deletion completes.
