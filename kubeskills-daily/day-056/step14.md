## Step 14: Test cluster autoscaler triggers

```bash
# In cloud environments, pending pods trigger autoscaling
echo "Cluster Autoscaler triggers:"
echo "- Pending pods due to insufficient resources"
echo "- Respects PodDisruptionBudgets"
echo "- Won't scale up for DaemonSet pods"
echo "- Scales down underutilized nodes"
```

Autoscaling reacts to pending workloads and eviction constraints.
