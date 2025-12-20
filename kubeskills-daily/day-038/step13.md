## Step 13: Fix NetworkPolicy to allow DNS

```bash
kubectl delete networkpolicy block-dns

cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
spec:
  podSelector:
    matchLabels:
      app: dns-blocked
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
  - to:
    - podSelector: {}
EOF

kubectl delete pod dns-blocked
kubectl apply -f - <<'EOF'
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
    command: ['sh', '-c', 'nslookup kubernetes.default; echo "Success!"; sleep 3600']
EOF
```{{exec}}

DNS now succeeds with kube-system UDP 53 allowed.
