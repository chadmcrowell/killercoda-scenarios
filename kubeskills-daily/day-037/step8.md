## Step 8: Test multiple containers sharing a volume

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: shared-volume
spec:
  securityContext:
    fsGroup: 2000
  containers:
  - name: writer
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      i=0
      while true; do
        i=$((i+1))
        echo "writer entry $i" >> /shared/log.txt
        sleep 5
      done
    securityContext:
      runAsUser: 1000
    volumeMounts:
    - name: shared
      mountPath: /shared
  - name: reader
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      while true; do
        echo "=== Latest log ==="
        tail -5 /shared/log.txt 2>&1 || echo "File not yet created"
        sleep 10
      done
    securityContext:
      runAsUser: 2000
    volumeMounts:
    - name: shared
      mountPath: /shared
  volumes:
  - name: shared
    emptyDir: {}
EOF
```{{exec}}

**Check both containers:**
```bash
kubectl logs shared-volume -c writer --tail=5
kubectl logs shared-volume -c reader --tail=10
```{{exec}}

Both containers can read/write because fsGroup grants shared group access.
