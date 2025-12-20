## Step 6: Test subPath permission behavior

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: subpath-test
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
      echo "Checking /data..."
      ls -la /data
      echo "Checking /data/subdir..."
      ls -la /data/subdir
      touch /data/test1.txt
      touch /data/subdir/test2.txt
      sleep 3600
    volumeMounts:
    - name: data
      mountPath: /data
    - name: data
      mountPath: /data/subdir
      subPath: subdir
  volumes:
  - name: data
    emptyDir: {}
EOF
```{{exec}}

**Check behavior:**
```bash
kubectl exec subpath-test -- ls -la /data
kubectl exec subpath-test -- ls -la /data/subdir
```{{exec}}

subPath can have different ownership behavior depending on the volume and kubelet.
