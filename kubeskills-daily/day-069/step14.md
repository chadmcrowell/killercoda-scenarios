## Step 14: Test service mesh debugging

```bash
cat > /tmp/mesh-diagnosis.sh << 'EOF'
#!/bin/bash
echo "=== Service Mesh Diagnosis ==="

echo -e "\n1. Namespaces with Sidecar Injection:"
kubectl get namespaces -L istio-injection,linkerd.io/inject

echo -e "\n2. Pods with Multiple Containers (potential sidecars):"
kubectl get pods -A -o json | jq -r '
  .items[] | 
  select((.spec.containers | length) > 1) |
  "\(.metadata.namespace)/\(.metadata.name): \(.spec.containers | length) containers"
' | head -10

echo -e "\n3. Pods Missing Expected Sidecar:"
kubectl get pods -n mesh-demo -o json | jq -r '
  .items[] |
  select((.spec.containers | length) == 1) |
  "\(.metadata.name): Only main container (no sidecar?)"
'

echo -e "\n4. NetworkPolicies (mTLS simulation):"
kubectl get networkpolicies -A

echo -e "\n5. Service Mesh Common Issues:"
echo "   - Missing sidecar: Namespace not labeled for injection"
echo "   - mTLS failure: Certificate issues or strict mode"
echo "   - Traffic blocked: NetworkPolicy or PeerAuthentication"
echo "   - High latency: Sidecar proxy overhead"
echo "   - Circuit breaker: Too many failures trigger break"
echo "   - Version conflict: Mismatched mesh version on nodes"
EOF

chmod +x /tmp/mesh-diagnosis.sh
/tmp/mesh-diagnosis.sh
```{{exec}}

Run a mesh diagnosis script to inspect common issues.
