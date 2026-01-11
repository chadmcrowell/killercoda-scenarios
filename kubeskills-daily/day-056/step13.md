## Step 13: Monitor scheduler metrics

```bash
# Check scheduler logs
kubectl logs -n kube-system -l component=kube-scheduler --tail=50 | grep -i "unschedulable\|insufficient"

# Check pending pod metrics
kubectl get pods -A --field-selector=status.phase=Pending | wc -l
```

Look for scheduling failures and backlog signals.
