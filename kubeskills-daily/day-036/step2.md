## Step 2: Check backoff timing

```bash
kubectl get events --sort-by='.lastTimestamp' | grep failing-job | tail -20
```{{exec}}

Look for timing between pod creations: ~10s, 20s, 40s, 80s.
