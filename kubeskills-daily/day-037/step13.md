## Step 13: Debug volume permissions

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: volume-debug
spec:
  containers:
  - name: debug
    image: busybox
    command: ['sleep', '3600']
    securityContext:
      privileged: true
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    emptyDir: {}
EOF
```{{exec}}

**Check from inside:**
```bash
kubectl exec volume-debug -- sh -c 'ls -la /data; df -h /data; mount | grep /data'
```{{exec}}

Use a privileged debug pod to inspect mounts and ownership.
