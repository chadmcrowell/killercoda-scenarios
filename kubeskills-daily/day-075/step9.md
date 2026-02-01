## Step 9: Test alert fatigue

```bash
# Create alerting rules
cat > /tmp/bad-alerts.yaml << 'EOF'
# Bad: Alerts on everything
- alert: PodNotReady
  expr: kube_pod_status_ready{condition="false"} > 0
  for: 10s  # Fires immediately!
  annotations:
    summary: "Pod not ready"

# Bad: No grouping
- alert: HighMemory
  expr: container_memory_usage_bytes > 100000000
  for: 1m
  # Fires for every container!

# Good: Actionable with context
- alert: CriticalServiceDown
  expr: up{job="critical-service"} == 0
  for: 5m  # Avoid flapping
  annotations:
    summary: "Critical service {{ $labels.instance }} down"
    runbook: "https://wiki/runbook/critical-service"
EOF

cat /tmp/bad-alerts.yaml

echo ""
echo "Alert fatigue causes:"
echo "- Alerts ignored"
echo "- Real incidents missed"
echo "- On-call burnout"
```{{exec}}

Poor alerting rules lead to alert fatigue.
