## Step 1: Deploy minimal container (no shell)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: minimal-app
spec:
  containers:
  - name: app
    image: gcr.io/distroless/static-debian11
    command: ['sleep', '3600']
EOF
```{{exec}}

Pod has no shell or package manager.
