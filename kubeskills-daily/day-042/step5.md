## Step 5: Test parser error (drops logs)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: unparseable-logs
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'while true; do echo "INVALID-JSON-LOG $(date)"; sleep 1; done']
EOF
```{{exec}}

```bash
kubectl logs -n logging -l app=fluent-bit --tail=100 | grep -i error
```{{exec}}

Parser errors appear for logs that do not match the JSON parser.
