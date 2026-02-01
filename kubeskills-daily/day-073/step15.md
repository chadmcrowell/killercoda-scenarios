## Step 15: Diagnose multi-tenancy issues

```bash
cat > /tmp/tenant-diagnosis.sh << 'EOF'
#!/bin/bash
echo "=== Multi-Tenancy Diagnosis ==="

echo -e "\n1. Tenant Namespaces:"
kubectl get namespaces -L tenant

echo -e "\n2. ResourceQuota Usage by Tenant:"
kubectl get resourcequota -A -o custom-columns=\
NAMESPACE:.metadata.namespace,\
CPU_USED:.status.used.'requests\.cpu',\
CPU_LIMIT:.status.hard.'requests\.cpu',\
PODS:.status.used.pods,\
POD_LIMIT:.status.hard.pods

echo -e "\n3. Cross-Namespace RBAC (Potential Issues):"
kubectl get clusterrolebindings -o json | jq -r '
  .items[] |
  select(.subjects[]?.kind == "ServiceAccount") |
  "\(.metadata.name): \(.subjects[0].namespace) -> \(.roleRef.name)"
' | head -10

echo -e "\n4. NetworkPolicies by Namespace:"
kubectl get networkpolicies -A

echo -e "\n5. Pod Distribution Across Nodes:"
kubectl get pods -A -o json | jq -r '
  .items[] |
  select(.metadata.namespace | startswith("team-")) |
  "\(.metadata.namespace)\t\(.spec.nodeName)"
' | sort | uniq -c

echo -e "\n6. Tenants Using Same Nodes:"
kubectl get pods -A -o wide | grep -E "team-" | awk '{print $8}' | sort | uniq -c

echo -e "\n7. High Priority Pods (Can Evict Others):"
kubectl get pods -A -o json | jq -r '
  .items[] |
  select(.spec.priorityClassName != null) |
  "\(.metadata.namespace)/\(.metadata.name): \(.spec.priorityClassName)"
' | head -10

echo -e "\n8. Common Multi-Tenancy Issues:"
echo "   - ClusterRole instead of Role: Cross-namespace access"
echo "   - No NetworkPolicy: Pod-to-pod communication across tenants"
echo "   - Shared nodes: Noisy neighbor problem"
echo "   - No PodSecurityPolicy/Standards: Privileged pods"
echo "   - Priority preemption: High priority evicts other tenants"
EOF

chmod +x /tmp/tenant-diagnosis.sh
/tmp/tenant-diagnosis.sh
```{{exec}}

Complete diagnostic output for multi-tenancy issues.
