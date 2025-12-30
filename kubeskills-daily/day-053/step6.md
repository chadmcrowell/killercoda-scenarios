## Step 6: Simulate zone partition

```bash
kubectl label pod split-test-0 zone=zone-a --overwrite
kubectl label pod split-test-1 zone=zone-b --overwrite
kubectl label pod split-test-2 zone=zone-b --overwrite

cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: zone-partition
spec:
  podSelector:
    matchLabels:
      zone: zone-a
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          zone: zone-a
  egress:
  - to:
    - podSelector:
        matchLabels:
          zone: zone-a
  - to:
    - namespaceSelector: {}
    ports:
    - protocol: UDP
      port: 53
EOF
```{{exec}}

Pods in zone-a cannot talk to zone-b.
