## Step 7: Test PVC permission issues

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: pvc-permissions
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
      echo "Volume permissions:"
      ls -la /data
      echo "Attempting write..."
      echo "test" > /data/file.txt
      cat /data/file.txt
      sleep 3600
    volumeMounts:
    - name: storage
      mountPath: /data
  volumes:
  - name: storage
    persistentVolumeClaim:
      claimName: test-pvc
EOF
```{{exec}}

**Check if it works:**
```bash
kubectl logs pvc-permissions
```{{exec}}

Some storage classes honor fsGroup automatically; others may need init perms.
