## Step 4: Test missing required field

```bash
cat <<EOF | kubectl apply -f -
apiVersion: example.com/v1
kind: WebApp
metadata:
  name: missing-field
spec:
  replicas: 3
  # Missing required 'image' field!
EOF

# Rejected by validation
```{{exec}}

Required field validation prevents incomplete resources.
