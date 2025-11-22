## Step 8: Check secret encryption at rest

```bash
kubectl get secret db-credentials -o yaml
```{{exec}}

The secret data is only base64 encoded by default. Real encryption at rest requires an API server `EncryptionConfiguration` and often a KMS provider.
