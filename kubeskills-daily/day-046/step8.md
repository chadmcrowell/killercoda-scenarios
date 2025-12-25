## Step 8: Test gRPC probe (K8s 1.24+)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: grpc-probe
spec:
  containers:
  - name: app
    image: hashicorp/http-echo
    args: ["-listen=:8080"]
    ports:
    - containerPort: 8080
    livenessProbe:
      grpc:
        port: 8080
      initialDelaySeconds: 5
EOF
```{{exec}}

gRPC probes call the gRPC health endpoint on port 8080.
