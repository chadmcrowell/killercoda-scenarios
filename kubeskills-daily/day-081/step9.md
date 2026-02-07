## Step 9: Simulate DNS failure

```bash
# Chaos with DNS
cat > /tmp/chaos-dns.yaml << 'EOF'
apiVersion: chaos-mesh.org/v1alpha1
kind: DNSChaos
metadata:
  name: dns-error
spec:
  action: error
  mode: all
  selector:
    labelSelectors:
      app: chaos-target
  patterns:
  - chaos-target.default.svc.cluster.local
  duration: "1m"
EOF

cat /tmp/chaos-dns.yaml

echo ""
echo "DNS failure chaos:"
echo "- Service name resolution fails"
echo "- Tests retry logic"
echo "- Reveals hard-coded IPs"
echo "- Exposes DNS caching issues"
```{{exec}}

DNS failures test whether applications handle name resolution errors gracefully or rely on DNS being always available.
