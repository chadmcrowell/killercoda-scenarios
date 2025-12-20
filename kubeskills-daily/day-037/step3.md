## Step 3: Test hostPath with permission error

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-denied
spec:
  securityContext:
    runAsUser: 1000
    runAsNonRoot: true
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'ls -la /host; echo "test" > /host/file.txt 2>&1 || echo "Permission denied!"']
    volumeMounts:
    - name: host
      mountPath: /host
  volumes:
  - name: host
    hostPath:
      path: /root
      type: Directory
EOF
```{{exec}}

**Check logs:**
```bash
kubectl logs hostpath-denied
```{{exec}}

Permission denied because user 1000 cannot write to /root.
