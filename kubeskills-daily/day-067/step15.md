## Step 15: Diagnose init container issues

```bash
cat > /tmp/init-diagnosis.sh << 'EOF'
#!/bin/bash
echo "=== Init Container Diagnosis ==="

echo -e "\n1. Pods Stuck in Init Phase:"
kubectl get pods -A --field-selector status.phase=Pending -o json | \
  jq -r '.items[] | select(.status.initContainerStatuses != null) | "\(.metadata.namespace)/\(.metadata.name): \(.status.phase)"'

echo -e "\n2. Failed Init Containers:"
kubectl get pods -A -o json | jq -r '
  .items[] | 
  select(.status.initContainerStatuses[]?.state.waiting?.reason == "CrashLoopBackOff" or
         .status.initContainerStatuses[]?.state.terminated?.exitCode != 0) |
  "\(.metadata.namespace)/\(.metadata.name): Init container failed"
'

echo -e "\n3. Init Container Restart Counts:"
kubectl get pods -A -o json | jq -r '
  .items[] | 
  select(.status.initContainerStatuses != null) |
  "\(.metadata.namespace)/\(.metadata.name): " + 
  (.status.initContainerStatuses | map("\(.name)=\(.restartCount)") | join(", "))
' | grep -v "=0" | head -10

echo -e "\n4. Recent Init Container Events:"
kubectl get events -A --sort-by='.lastTimestamp' | grep -i "init" | tail -10

echo -e "\n5. Init Container Status by Pod:"
kubectl get pods -A -o json | jq -r '
  .items[] |
  select(.status.initContainerStatuses != null) |
  "\(.metadata.namespace)/\(.metadata.name):" + 
  " \(.status.initContainerStatuses | length) init containers, " +
  "Phase: \(.status.phase)"
' | head -10

echo -e "\n6. Common Init Container Issues:"
echo "   - Failing dependency: Service/resource not ready"
echo "   - Exit code 1: Command failed"
echo "   - CrashLoopBackOff: Repeated failures"
echo "   - Timeout: Long-running init taking too long"
echo "   - Volume issues: Can't mount shared volumes"
EOF

chmod +x /tmp/init-diagnosis.sh
/tmp/init-diagnosis.sh
```{{exec}}

Run a script to summarize init container health.
