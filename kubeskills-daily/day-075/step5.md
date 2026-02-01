## Step 5: Test log collection failure

```bash
# Create pod that logs to stdout
kubectl run logger --image=busybox --command -- sh -c 'while true; do echo "Log message $(date)"; sleep 1; done'

# Logs visible while pod runs
kubectl logs logger --tail=5

# Delete pod
kubectl delete pod logger

# Logs lost!
kubectl logs logger 2>&1 || echo "Logs lost when pod deleted!"

echo "Without log aggregation (Fluentd/Loki), logs disappear"
```{{exec}}

Logs are lost when pods are deleted without aggregation.
