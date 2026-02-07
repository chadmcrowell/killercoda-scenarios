## Step 5: Test Priority and Fairness queuing

```bash
# Check priority levels
kubectl get prioritylevelconfigurations

echo ""
echo "Priority Levels (default):"
echo "- system: Critical system components (highest)"
echo "- leader-election: Controller leader election"
echo "- workload-high: User workloads (high)"
echo "- workload-low: User workloads (low)"
echo "- global-default: Everything else"
echo ""
echo "Lower priority requests queued when system busy"
```{{exec}}

Priority and Fairness (APF) assigns requests to priority levels - lower priority requests are queued when the system is busy.
