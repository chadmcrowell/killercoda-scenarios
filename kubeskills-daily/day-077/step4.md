## Step 4: Secret logged to stdout

```bash
# Pod that logs secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: logging-secret
spec:
  containers:
  - name: app
    image: busybox
    command:
    - sh
    - -c
    - |
      echo "Starting application..."
      echo "Database password: \$DB_PASSWORD"
      echo "Connecting to database..."
      sleep 3600
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-creds
          key: password
EOF

kubectl wait --for=condition=Ready pod logging-secret --timeout=60s

# Secret in logs!
kubectl logs logging-secret | grep -i password
```{{exec}}

Secret leaked to logs - visible to anyone with log access!
