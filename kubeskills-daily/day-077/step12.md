## Step 12: Secret in error messages

```bash
# Application that exposes secrets in errors
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: error-secret-pod
spec:
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - |
      DB_PASS=\$DB_PASSWORD
      echo "Trying to connect to database..."
      # Simulate connection error
      echo "ERROR: Failed to connect to db with password: \$DB_PASS" >&2
      exit 1
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-creds
          key: password
EOF

sleep 10

# Secret in error output
kubectl logs error-secret-pod 2>&1 | grep ERROR
```{{exec}}

Secret leaked in error messages! Applications must sanitize error output to avoid exposing credentials.
