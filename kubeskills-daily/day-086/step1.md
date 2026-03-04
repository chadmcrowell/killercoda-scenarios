# Investigate the Problem

Examine the cluster state and identify symptoms.

```bash
kubectl get pods -A
kubectl get events --sort-by=.lastTimestamp
```