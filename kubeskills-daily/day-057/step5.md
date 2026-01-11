## Step 5: Test baseline violations

```bash
# Try privileged container (BLOCKED by baseline)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: blocked-privileged
  namespace: baseline-ns
spec:
  containers:
  - name: app
    image: nginx
    securityContext:
      privileged: true
EOF
```{{exec}}

Expected error: violates PodSecurity baseline due to privileged container.
