## Step 11: Test restricted violations - missing seccomp

```bash
# Try without seccomp profile (BLOCKED)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: blocked-seccomp
  namespace: restricted-ns
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
  containers:
  - name: app
    image: nginx
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
EOF
```{{exec}}

Expected error: violates restricted due to missing seccompProfile.
