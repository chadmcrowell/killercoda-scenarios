## Step 6: Test ndots search domain expansion

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: ndots-test
spec:
  containers:
  - name: test
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      echo "=== Resolving 'kubernetes' (short name) ==="
      time nslookup kubernetes
      echo ""
      echo "=== Resolving 'kubernetes.default.svc.cluster.local' (FQDN) ==="
      time nslookup kubernetes.default.svc.cluster.local
      sleep 3600
EOF
```{{exec}}

```bash
kubectl logs ndots-test
```{{exec}}

Short names try all search domains first (slower).
