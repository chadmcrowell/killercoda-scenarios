## Step 9: Test volume from Secret

```bash
kubectl create secret generic secret-test --from-literal=key=value

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secret-volume
spec:
  securityContext:
    runAsUser: 1000
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      echo "Secret permissions:"
      ls -la /secrets
      echo "Reading secret:"
      cat /secrets/key
      echo "Attempting write:"
      echo "new" > /secrets/key 2>&1 || echo "Cannot write to secret volume"
      sleep 3600
    volumeMounts:
    - name: secret
      mountPath: /secrets
  volumes:
  - name: secret
    secret:
      secretName: secret-test
      defaultMode: 0400
EOF
```{{exec}}

**Check:**
```bash
kubectl logs secret-volume
```{{exec}}

Secret volumes are read-only; writes fail.
