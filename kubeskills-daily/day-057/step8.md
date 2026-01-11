## Step 8: Deploy baseline-compliant pod

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: baseline-compliant
  namespace: baseline-ns
spec:
  containers:
  - name: app
    image: nginx
    securityContext:
      allowPrivilegeEscalation: false
EOF
```{{exec}}

Baseline-compliant pod should start successfully.
