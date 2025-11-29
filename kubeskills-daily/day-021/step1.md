## Step 1: Create a simple resource with finalizer

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: test-cm
  finalizers:
  - example.com/finalizer
data:
  key: value
EOF
```{{exec}}

Finalizer will block deletion until explicitly removed.
