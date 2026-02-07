## Step 1: Create basic secret

```bash
# Create secret
kubectl create secret generic db-creds \
  --from-literal=username=admin \
  --from-literal=password=supersecret123

# View secret (base64 encoded)
kubectl get secret db-creds -o yaml
```{{exec}}

Create a Kubernetes secret and observe that values are only base64 encoded, not encrypted.
