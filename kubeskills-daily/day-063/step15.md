## Step 15: Diagnose DNS issues

```bash
cat > /tmp/dns-diagnosis.sh << 'EOF'
#!/bin/bash
echo "=== DNS Diagnosis Report ==="

echo -e "\n1. CoreDNS Pod Status:"
kubectl get pods -n kube-system -l k8s-app=kube-dns -o wide

echo -e "\n2. CoreDNS Service:"
kubectl get svc -n kube-system kube-dns

echo -e "\n3. CoreDNS Configuration:"
kubectl get configmap -n kube-system coredns -o jsonpath='{.data.Corefile}' | head -20

echo -e "\n4. CoreDNS Logs (recent errors):"
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=20 | grep -i "error\|fail" || echo "No errors found"

echo -e "\n5. Test DNS Resolution:"
TEST_POD=$(kubectl get pods -o name | head -1 | cut -d'/' -f2)
if [ -n "$TEST_POD" ]; then
  echo "Testing from pod: $TEST_POD"
  kubectl exec $TEST_POD -- nslookup kubernetes.default 2>&1 | head -5
else
  echo "No test pod available"
fi

echo -e "\n6. DNS Query Performance:"
kubectl exec dns-test -- sh -c 'time nslookup kubernetes.default' 2>&1 | grep real

echo -e "\n7. CoreDNS Resource Usage:"
kubectl top pod -n kube-system -l k8s-app=kube-dns 2>/dev/null || echo "Metrics not available"

echo -e "\n8. Common DNS Issues:"
echo "   - CoreDNS pods down: All DNS fails"
echo "   - Corrupted config: CoreDNS crashes"
echo "   - Forward loop: Queries never resolve"
echo "   - Upstream unreachable: External DNS fails"
echo "   - High ndots: Many unnecessary queries"
echo "   - Cache issues: Stale DNS records"
EOF

chmod +x /tmp/dns-diagnosis.sh
/tmp/dns-diagnosis.sh
```{{exec}}

Run a script that summarizes DNS health and common failure modes.
