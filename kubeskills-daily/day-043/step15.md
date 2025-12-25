## Step 15: Test long-running traces

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: slow-service
spec:
  containers:
  - name: app
    image: curlimages/curl:latest
    command: ['sh', '-c']
    args:
    - |
      while true; do
        nc -l -p 8080 -e sh -c '
          sleep 30
          echo "HTTP/1.1 200 OK"
          echo ""
          echo "Slow response"
        '
      done
EOF
```{{exec}}

Long operations create long spans; observe duration in Jaeger.
