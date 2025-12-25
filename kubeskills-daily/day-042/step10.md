## Step 10: Test multiline log parsing

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: multiline-logs
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      while true; do
        echo "Exception in thread main:"
        echo "  at line 1"
        echo "  at line 2"
        echo "  at line 3"
        sleep 5
      done
EOF
```{{exec}}

Without a multiline parser, each line is a separate log entry.
