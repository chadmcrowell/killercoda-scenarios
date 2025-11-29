## Step 10: Custom resource with controller finalizer

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: finalizer-test
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: controlled-resource
  namespace: finalizer-test
  finalizers:
  - operator.example.com/cleanup
data:
  managed: "true"
EOF
```{{exec}}

```bash
kubectl delete configmap controlled-resource -n finalizer-test
kubectl get configmap -n finalizer-test
```{{exec}}

Resource remains until controller would remove the finalizer.
