## Step 15: Diagnose quota issues

```bash
cat > /tmp/quota-diagnosis.sh << 'EOF'
#!/bin/bash
echo "=== Resource Quota Diagnosis ==="

echo -e "\n1. Quota Status by Namespace:"
kubectl get resourcequota -A -o custom-columns=\
NAMESPACE:.metadata.namespace,\
NAME:.metadata.name,\
PODS:.status.used.pods,\
POD_LIMIT:.status.hard.pods,\
CPU:.status.used.'requests\.cpu',\
CPU_LIMIT:.status.hard.'requests\.cpu'

echo -e "\n2. Namespaces Hitting Quota Limits:"
kubectl get resourcequota -A -o json | jq -r '
  .items[] | 
  select(.status.used.pods == .status.hard.pods or 
         .status.used["requests.cpu"] >= .status.hard["requests.cpu"]) |
  "\(.metadata.namespace)/\(.metadata.name): Near or at limit"
'

echo -e "\n3. Recent Quota-Related Events:"
kubectl get events -A --sort-by='.lastTimestamp' | grep -i quota | tail -10

echo -e "\n4. Pods That Failed Due to Quota:"
kubectl get events -A -o json | jq -r '
  .items[] | 
  select(.reason == "FailedCreate" and (.message | contains("quota"))) |
  "\(.involvedObject.namespace)/\(.involvedObject.name): \(.message)"
' | tail -10

echo -e "\n5. LimitRanges (provide defaults):"
kubectl get limitrange -A

echo -e "\n6. Recommendations:"
echo "   - Increase quota if team needs more resources"
echo "   - Add LimitRange to provide defaults"
echo "   - Use different QoS classes (BestEffort, Burstable, Guaranteed)"
echo "   - Monitor quota usage with alerts"
EOF

chmod +x /tmp/quota-diagnosis.sh
/tmp/quota-diagnosis.sh
```{{exec}}

Run a quota diagnosis script for quick insights.
