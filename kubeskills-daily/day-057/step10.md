## Step 10: Test restricted violations - running as root

```bash
# Try running as root (BLOCKED by restricted)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: blocked-root
  namespace: restricted-ns
spec:
  containers:
  - name: app
    image: nginx
    securityContext:
      allowPrivilegeEscalation: false
EOF
```{{exec}}

Expected error: violates restricted because runAsNonRoot is missing.
