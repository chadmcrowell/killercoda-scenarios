## Step 14: Test sidecar logging pattern

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: sidecar-logging
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'while true; do echo "App log" >> /var/log/app.log; sleep 1; done']
    volumeMounts:
    - name: logs
      mountPath: /var/log
  - name: log-shipper
    image: busybox
    command: ['sh', '-c', 'tail -f /var/log/app.log']
    volumeMounts:
    - name: logs
      mountPath: /var/log
  volumes:
  - name: logs
    emptyDir: {}
EOF
```{{exec}}

```bash
kubectl logs sidecar-logging -c log-shipper
```{{exec}}

Sidecar tails the app log file from a shared volume.
