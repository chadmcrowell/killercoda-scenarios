## Step 15: Diagnose Job and CronJob issues

```bash
cat > /tmp/job-diagnosis.sh << 'EOF'
#!/bin/bash
echo "=== Job & CronJob Diagnosis ==="

echo -e "\n1. Failed Jobs:"
kubectl get jobs -A --field-selector status.successful=0

echo -e "\n2. Long-Running Jobs:"
kubectl get jobs -A -o json | jq -r '
  .items[] | 
  select(.status.active > 0 and .status.startTime != null) |
  "\(.metadata.namespace)/\(.metadata.name): Running for \((now - (.status.startTime | fromdateiso8601)) / 60 | floor) minutes"
' | head -10

echo -e "\n3. CronJob Status:"
kubectl get cronjobs -A -o custom-columns=\
NAMESPACE:.metadata.namespace,\
NAME:.metadata.name,\
SCHEDULE:.spec.schedule,\
SUSPEND:.spec.suspend,\
LAST_SCHEDULE:.status.lastScheduleTime

echo -e "\n4. CronJobs Missing Schedules:"
kubectl get events -A --sort-by='.lastTimestamp' | grep "FailedNeedsStart\|MissSchedule" | tail -10

echo -e "\n5. Job Pods by Status:"
kubectl get pods -A -l batch.kubernetes.io/controller-uid -o json | \
  jq -r '.items | group_by(.status.phase) | map({phase: .[0].status.phase, count: length}) | .[] | "\(.phase): \(.count)"'

echo -e "\n6. Jobs Without TTL (won't auto-cleanup):"
kubectl get jobs -A -o json | \
  jq -r '.items[] | select(.spec.ttlSecondsAfterFinished == null) | "\(.metadata.namespace)/\(.metadata.name)"' | head -10

echo -e "\n7. Recent Job Events:"
kubectl get events -A --sort-by='.lastTimestamp' | grep -i "job\|cronjob" | tail -10

echo -e "\n8. Common Job/CronJob Issues:"
echo "   - BackoffLimit reached: Too many failures"
echo "   - ActiveDeadlineSeconds: Job timeout"
echo "   - Schedule missed: Previous run still active (Forbid policy)"
echo "   - Wrong restartPolicy: Must be Never or OnFailure"
echo "   - No TTL: Completed jobs accumulate"
echo "   - Concurrency issues: Multiple runs overlap"
EOF

chmod +x /tmp/job-diagnosis.sh
/tmp/job-diagnosis.sh
```{{exec}}

Run a script to summarize job and cronjob issues.
