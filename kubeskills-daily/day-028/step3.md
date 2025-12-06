## Step 3: Test baseline with privileged container (should fail)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: privileged-fail
  namespace: psa-baseline
spec:
  containers:
  - name: ubuntu
    image: ubuntu:22.04
    command: ["sh", "-c", "sleep 1h"]
    securityContext:
      privileged: true
EOF
```{{exec}}

This should be forbidden: privileged containers violate baseline.
