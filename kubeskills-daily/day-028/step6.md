## Step 6: Try baseline-compliant pod in restricted namespace

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: baseline-pod
  namespace: psa-restricted
spec:
  containers:
  - name: ubuntu
    image: ubuntu:22.04
    command: ["sh", "-c", "sleep 1h"]
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
EOF
```{{exec}}

This should fail listing all restricted violations (runAsNonRoot, seccomp, etc.).
