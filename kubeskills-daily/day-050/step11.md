## Step 11: Test DaemonSet tolerance

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-monitor
spec:
  selector:
    matchLabels:
      app: monitor
  template:
    metadata:
      labels:
        app: monitor
    spec:
      containers:
      - name: monitor
        image: busybox
        command: ['sh', '-c', 'while true; do echo "Monitoring..."; sleep 60; done']
EOF

kubectl get pod -l app=monitor -o jsonpath='{.items[0].spec.tolerations}' | jq .
```{{exec}}

DaemonSets tolerate NotReady/Unreachable indefinitely and stay on tainted nodes.
