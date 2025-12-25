## Step 3: Expose Prometheus UI

```bash
kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090 > /dev/null 2>&1 &
```{{exec}}

Port-forward Prometheus to localhost:9090 to check targets and rules.
