## Step 12: Test SecurityContext conflicts

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: security-conflict
spec:
  securityContext:
    runAsUser: 1000
    fsGroup: 2000
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'id; ls -la /data; sleep 3600']
    securityContext:
      runAsUser: 3000
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    emptyDir: {}
EOF
```{{exec}}

**Check effective user:**
```bash
kubectl logs security-conflict
```{{exec}}

Container-level securityContext overrides pod-level runAsUser.
