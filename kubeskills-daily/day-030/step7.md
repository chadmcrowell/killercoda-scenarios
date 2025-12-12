## Step 7: Correct way - use status subresource

```bash
kubectl patch webapp test-app --subresource=status --type=merge -p '{"status":{"phase":"Ready","configMapName":"test-app-config"}}'

# Check spec resourceVersion
kubectl get webapp test-app -o jsonpath='{.metadata.resourceVersion}'
echo ""
```{{exec}}

Status subresource avoids spec resourceVersion bumps, preventing unnecessary loops.
