## Step 2: Create namespace with baseline enforcement

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: psa-baseline
  labels:
    pod-security.kubernetes.io/enforce: "baseline"
    pod-security.kubernetes.io/enforce-version: "latest"
    pod-security.kubernetes.io/warn: "baseline"
    pod-security.kubernetes.io/audit: "baseline"
EOF
```{{exec}}

```bash
kubectl get namespace psa-baseline -o yaml | grep -A 5 labels
```{{exec}}

Labels set baseline enforcement/warn/audit.
