## Step 7: Fix restricted requirements

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: restricted-compliant
  namespace: psa-restricted
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: ubuntu
    image: ubuntu:22.04
    command: ["sh", "-c", "sleep 1h"]
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
      runAsNonRoot: true
      runAsUser: 1000
EOF
```{{exec}}

```bash
kubectl get pod restricted-compliant -n psa-restricted
```{{exec}}

This meets restricted profile requirements.
