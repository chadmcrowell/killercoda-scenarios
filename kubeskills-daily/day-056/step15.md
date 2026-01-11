## Step 15: Capacity planning report

```bash
cat > /tmp/capacity-report.sh << 'EOF'
#!/bin/bash
echo "=== Cluster Capacity Report ==="

echo -e "\n1. Node Resources:"
kubectl top nodes

echo -e "\n2. Total Allocatable:"
kubectl describe nodes | grep "Allocatable:" -A 5 | grep -E "cpu:|memory:"

echo -e "\n3. Total Allocated:"
kubectl describe nodes | grep "Allocated resources:" -A 10 | tail -5

echo -e "\n4. Pending Pods:"
kubectl get pods -A --field-selector=status.phase=Pending | tail -n +2 | wc -l

echo -e "\n5. Resource Requests by Namespace:"
kubectl get pods -A -o json | jq -r '
  .items | 
  group_by(.metadata.namespace) | 
  map({
    namespace: .[0].metadata.namespace,
    cpu_requests: (map(.spec.containers[].resources.requests.cpu // "0" | gsub("m";"") | tonumber) | add),
    memory_requests: (map(.spec.containers[].resources.requests.memory // "0Mi" | gsub("Mi|Gi";"") | tonumber) | add)
  }) | 
  .[] | 
  "\(.namespace): \(.cpu_requests)m CPU, \(.memory_requests)Mi RAM"
'

echo -e "\n6. Largest Pods:"
kubectl get pods -A -o json | jq -r '
  .items | 
  map({
    name: "\(.metadata.namespace)/\(.metadata.name)",
    cpu: (.spec.containers[].resources.requests.cpu // "0m"),
    memory: (.spec.containers[].resources.requests.memory // "0Mi")
  }) | 
  sort_by(.cpu) | 
  reverse | 
  .[:5] | 
  .[] | 
  "\(.name): \(.cpu) CPU, \(.memory) RAM"
'
EOF

chmod +x /tmp/capacity-report.sh
/tmp/capacity-report.sh
```

Generate a quick capacity report for planning.
