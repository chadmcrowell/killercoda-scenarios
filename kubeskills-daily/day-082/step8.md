## Step 8: Test secret drift

```bash
# Create secret
kubectl create secret generic myapp-secret --from-literal=password=original123

# Update secret (not in Git)
kubectl create secret generic myapp-secret \
  --from-literal=password=changed456 \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Secret updated directly"
echo ""
echo "Original: password=original123"
echo "Current: password=changed456"
echo ""
echo "Drift: Secret rotation not documented"
```{{exec}}

Secret updates applied directly are especially dangerous - undocumented credential changes can break applications silently.
