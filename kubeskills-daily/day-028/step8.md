## Step 8: Test mixed enforcement modes

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: psa-mixed
  labels:
    pod-security.kubernetes.io/enforce: "baseline"
    pod-security.kubernetes.io/warn: "restricted"
    pod-security.kubernetes.io/audit: "restricted"
EOF
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: mixed-mode-pod
  namespace: psa-mixed
spec:
  containers:
  - name: app
    image: nginx
    securityContext:
      allowPrivilegeEscalation: false
EOF
```{{exec}}

Expect creation with warn/audit messages for restricted violations.
