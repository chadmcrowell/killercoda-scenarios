## Step 13: Test operator reconciliation failure

```bash
# Create CR that operator can't handle
cat <<EOF | kubectl apply -f -
apiVersion: example.com/v1
kind: WebApp
metadata:
  name: unreconcilable
spec:
  replicas: 3
  image: "invalid@image@format"
EOF

# Operator would fail to reconcile this
kubectl get webapp unreconcilable
kubectl describe webapp unreconcilable
```{{exec}}

Custom resource with invalid image format that would cause operator reconciliation failures.
