## Step 14: Test pod eviction with finalizers

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: finalizer-pod
  finalizers:
  - example.com/block-eviction
spec:
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl delete pod finalizer-pod &

kubectl get pod finalizer-pod
```{{exec}}

The pod stays Terminating until the finalizer is removed.

```bash
kubectl patch pod finalizer-pod -p '{"metadata":{"finalizers":[]}}'
```{{exec}}

Removing the finalizer lets deletion complete.
