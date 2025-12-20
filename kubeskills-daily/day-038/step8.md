## Step 8: Test DNS timeout configuration

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: dns-timeout
spec:
  dnsConfig:
    options:
    - name: timeout
      value: "1"
    - name: attempts
      value: "2"
  containers:
  - name: test
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      echo "Resolving bad host to show fast failure..."
      nslookup doesnotexist.svc.cluster.local || echo "Failed fast"
      sleep 3600
EOF
```{{exec}}

```bash
kubectl logs dns-timeout
```{{exec}}

Fails quickly due to timeout=1 and attempts=2.
