## Step 2: Run as non-root, still succeeds on emptyDir

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nonroot-fail
spec:
  securityContext:
    runAsUser: 1000
    runAsNonRoot: true
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      echo "Writing as user 1000..."
      echo "nonroot" > /data/file.txt
      cat /data/file.txt
      sleep 3600
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    emptyDir: {}
EOF
```{{exec}}

**Check logs:**
```bash
kubectl logs nonroot-fail 2>&1
```{{exec}}

Still works because emptyDir is writable for any user.
