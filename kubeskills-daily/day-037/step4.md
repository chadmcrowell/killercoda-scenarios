## Step 4: Use fsGroup to fix permissions

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: fsgroup-fix
spec:
  securityContext:
    runAsUser: 1000
    fsGroup: 2000
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      echo "Checking ownership..."
      ls -la /data
      echo "Writing file..."
      echo "test" > /data/file.txt
      echo "Reading file..."
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

**Check ownership:**
```bash
kubectl exec fsgroup-fix -- ls -la /data
```{{exec}}

Group ownership is 2000 from fsGroup, allowing writes.
