## Step 7: Secret mounted as volume

```bash
# Mount secret as volume
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: volume-secret-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: secret-volume
      mountPath: /etc/secrets
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: db-creds
EOF

kubectl wait --for=condition=Ready pod volume-secret-pod --timeout=60s

# Secret files readable
kubectl exec volume-secret-pod -- ls -la /etc/secrets
kubectl exec volume-secret-pod -- cat /etc/secrets/password
```{{exec}}

Volume-mounted secrets are files on disk - better than env vars since they auto-update and don't leak to /proc.
