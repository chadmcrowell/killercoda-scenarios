## Step 6: Test label drift

```bash
# Add label that's not in Git
kubectl label deployment myapp patched=true

echo "Label added directly to deployment"
echo ""
echo "Current labels:"
kubectl get deployment myapp -o jsonpath='{.metadata.labels}' | jq .

echo ""
echo "Git doesn't have 'patched=true' label"
```{{exec}}

Adding labels directly creates metadata drift that can affect selectors, monitoring, and policy enforcement.
