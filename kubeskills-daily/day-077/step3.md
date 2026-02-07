## Step 3: Secret in environment variable

```bash
# Deploy pod with secret as env var
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: env-secret-pod
spec:
  containers:
  - name: app
    image: nginx
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-creds
          key: password
EOF

kubectl wait --for=condition=Ready pod env-secret-pod --timeout=60s

# Secret visible in /proc
kubectl exec env-secret-pod -- cat /proc/1/environ | tr '\0' '\n' | grep DB_PASSWORD
```{{exec}}

Secret exposed in process environment! Environment variables are visible in /proc for any process in the container.
