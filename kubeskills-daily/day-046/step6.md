## Step 6: Test exec probe

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: exec-probe
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'touch /tmp/healthy; sleep 3600']
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 10
EOF
```{{exec}}

```bash
kubectl exec exec-probe -- rm /tmp/healthy || true
kubectl get pod exec-probe -w
```{{exec}}

Removing the file causes probe failure and restart.
