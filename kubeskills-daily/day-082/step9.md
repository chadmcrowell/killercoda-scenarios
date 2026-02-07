## Step 9: Test annotation drift

```bash
# Add annotations manually
kubectl annotate deployment myapp \
  last-modified-by="admin" \
  change-reason="performance-tuning"

echo "Annotations added manually"
echo ""
kubectl get deployment myapp -o jsonpath='{.metadata.annotations}' | jq .

echo ""
echo "Git: No annotations"
echo "Drift: Undocumented metadata"
```{{exec}}

Annotations added manually create invisible drift - they affect tooling behavior without any version control record.
