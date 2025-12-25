## Step 13: Check probe metrics

```bash
kubectl describe pod tuned-probes | grep -A 10 -E "Liveness|Readiness|Startup"

kubectl get events --field-selector involvedObject.name=tuned-probes --sort-by='.lastTimestamp'
```{{exec}}

Describe and events show recent probe successes/failures.
