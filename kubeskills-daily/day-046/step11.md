## Step 11: Test custom health endpoint

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: custom-health
spec:
  containers:
  - name: app
    image: hashicorp/http-echo
    args: ["-text=Healthy", "-listen=:8080"]
    ports:
    - containerPort: 8080
    livenessProbe:
      httpGet:
        path: /healthz
        port: 8080
        httpHeaders:
        - name: X-Custom-Header
          value: ProbeRequest
      initialDelaySeconds: 5
      periodSeconds: 10
EOF
```{{exec}}

Custom path and headers for health checks.
