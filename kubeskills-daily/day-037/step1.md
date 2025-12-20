## Step 1: Create pod with emptyDir (works by default)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: emptydir-test
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      echo "Writing file to emptyDir..."
      echo "hello" > /data/file.txt
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
kubectl logs emptydir-test
```{{exec}}

Works: emptyDir is writable by default.
