## Step 11: Test initContainer volume preparation

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-prepares-volume
spec:
  initContainers:
  - name: setup
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      echo "Setting up volume..."
      mkdir -p /data/app
      echo "config" > /data/app/config.txt
      chmod 777 /data/app
    volumeMounts:
    - name: data
      mountPath: /data
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'ls -la /data; cat /data/app/config.txt; sleep 3600']
    securityContext:
      runAsUser: 1000
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    emptyDir: {}
EOF
```{{exec}}

**Verify:**
```bash
kubectl logs init-prepares-volume -c setup
kubectl logs init-prepares-volume -c app
```{{exec}}
