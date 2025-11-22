## Step 5: Check HPA events

```bash
kubectl describe hpa cpu-app-hpa | tail -20
```{{exec}}

Look for scale decisions like `New size: X; reason: cpu resource utilization` to see timing and triggers.
