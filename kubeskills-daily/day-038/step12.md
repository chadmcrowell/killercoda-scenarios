## Step 12: Test NetworkPolicy blocking DNS

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-dns
spec:
  podSelector:
    matchLabels:
      app: dns-blocked
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector: {}
---
apiVersion: v1
kind: Pod
metadata:
  name: dns-blocked
  labels:
    app: dns-blocked
spec:
  containers:
  - name: test
    image: busybox
    command: ['sh', '-c', 'nslookup kubernetes.default; sleep 3600']
EOF
```{{exec}}

```bash
kubectl logs dns-blocked 2>&1
```{{exec}}

DNS times out because egress to CoreDNS is blocked.
