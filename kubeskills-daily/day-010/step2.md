## Step 2: Deploy app with secret as env vars AND volume

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secret-app
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'while true; do echo "=== ENV VAR ==="; echo "DB_PASS=$DB_PASSWORD"; echo "=== VOLUME ==="; cat /secrets/password; echo ""; sleep 10; done']
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: password
    volumeMounts:
    - name: secret-volume
      mountPath: /secrets
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: db-credentials
EOF
```{{exec}}

```bash
kubectl logs secret-app -f
```{{exec}}

Both env and volume show `supersecret123`; keep the log stream running.
