## Step 3: Check pull backoff timing

```bash
kubectl get events --field-selector involvedObject.name=private-image-fail --sort-by='.lastTimestamp'
```{{exec}}

Note the exponential backoff: immediate, 10s, 20s, 40s, and up to 5 minutes between attempts.
