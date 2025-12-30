## Step 13: Test storage version migration

```bash
kubectl get crd crontabs.stable.example.com -o jsonpath='{.status.storedVersions}'; echo ""
```

Multiple stored versions indicate migration work after upgrades.
