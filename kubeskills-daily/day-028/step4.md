## Step 4: Deploy compliant pod in baseline namespace

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: baseline-ok
  namespace: psa-baseline
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

```bash
kubectl get pod baseline-ok -n psa-baseline
```{{exec}}

Baseline allows this hardened pod.
