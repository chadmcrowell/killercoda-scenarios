## Step 12: Test init container with secret

```bash
# Create secret
kubectl create secret generic db-creds \
  --from-literal=username=admin \
  --from-literal=password=secret123

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-secret
spec:
  initContainers:
  - name: check-secret
    image: busybox
    command:
    - sh
    - -c
    - |
      echo "Checking credentials..."
      if [ -f /secrets/username ]; then
        echo "Credentials found!"
      else
        echo "Credentials missing!"
        exit 1
      fi
    volumeMounts:
    - name: secrets
      mountPath: /secrets
      readOnly: true
  containers:
  - name: app
    image: nginx
  volumes:
  - name: secrets
    secret:
      secretName: db-creds
EOF

kubectl wait --for=condition=Ready pod init-secret --timeout=60s
kubectl logs init-secret -c check-secret
```{{exec}}

Validate secrets access from init containers.
