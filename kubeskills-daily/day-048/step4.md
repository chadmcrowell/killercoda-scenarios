## Step 4: Create resource with deprecated API (simulation)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-version-test
  annotations:
    deprecated-by: "apps/v1"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test
  template:
    metadata:
      labels:
        app: test
    spec:
      containers:
      - name: nginx
        image: nginx
EOF
```{{exec}}

```bash
kubectl get deployment api-version-test -o yaml | grep "apiVersion:"
```{{exec}}

Confirms the stored apiVersion.
