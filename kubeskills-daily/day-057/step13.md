## Step 13: Test warn mode

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: warn-ns
  labels:
    pod-security.kubernetes.io/enforce: privileged
    pod-security.kubernetes.io/warn: restricted
    pod-security.kubernetes.io/audit: restricted
EOF

# Deploy non-compliant pod
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: warned-pod
  namespace: warn-ns
spec:
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

Warn mode allows the pod but emits warnings.
