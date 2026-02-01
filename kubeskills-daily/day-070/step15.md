## Step 15: Diagnose autoscaling issues

```bash
cat > /tmp/autoscaling-diagnosis.sh << 'EOF'
#!/bin/bash
echo "=== Autoscaling Diagnosis ==="

echo -e "\n1. HPA Status:"
kubectl get hpa -A -o custom-columns=\
NAMESPACE:.metadata.namespace,\
NAME:.metadata.name,\
TARGETS:.status.currentMetrics[0].resource.current.averageUtilization,\
MINPODS:.spec.minReplicas,\
MAXPODS:.spec.maxReplicas,\
REPLICAS:.status.currentReplicas

echo -e "\n2. HPAs Unable to Get Metrics:"
kubectl get hpa -A -o json | jq -r '
  .items[] | 
  select(.status.conditions[]? | .type == "ScalingActive" and .status == "False") |
  "\(.metadata.namespace)/\(.metadata.name): \(.status.conditions[] | select(.type == "ScalingActive").message)"
'

echo -e "\n3. HPAs Without Resource Requests:"
kubectl get hpa -A -o json | jq -r '
  .items[] |
  .metadata.namespace as $ns |
  .spec.scaleTargetRef.name as $target |
  select(.spec.metrics[]?.resource.name == "cpu" or .spec.metrics[]?.resource.name == "memory") |
  "\($ns)/\(.metadata.name) targets \($target)"
' | while read line; do
  ns=$(echo $line | cut -d/ -f1)
  target=$(echo $line | awk '{print $NF}')
  requests=$(kubectl get deployment -n $ns $target -o jsonpath='{.spec.template.spec.containers[0].resources.requests}' 2>/dev/null)
  if [ -z "$requests" ] || [ "$requests" == "null" ]; then
    echo "$line: No resource requests!"
  fi
done

echo -e "\n4. VPAs (if installed):"
kubectl get vpa -A 2>/dev/null || echo "VPA not installed"

echo -e "\n5. Metrics Server Status:"
kubectl get deployment -n kube-system metrics-server 2>/dev/null || echo "Metrics-server not found"

echo -e "\n6. Recent HPA Events:"
kubectl get events -A --sort-by='.lastTimestamp' | grep -i "horizontalpodautoscaler\|hpa" | tail -10

echo -e "\n7. Common Autoscaling Issues:"
echo "   - No metrics-server: HPA can't get CPU/memory"
echo "   - No resource requests: Can't calculate utilization"
echo "   - Target too low: Constantly scaling up"
echo "   - HPA + VPA conflict: Both try to control same resource"
echo "   - Slow metrics: Delayed scaling decisions"
echo "   - Min = Max: Can't autoscale at all"
EOF

chmod +x /tmp/autoscaling-diagnosis.sh
/tmp/autoscaling-diagnosis.sh
```{{exec}}

Run diagnosis to identify common autoscaling blockers.
