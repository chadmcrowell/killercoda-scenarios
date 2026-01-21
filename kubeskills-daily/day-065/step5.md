## Step 5: Create imagePullSecret

```bash
# Create docker registry secret
kubectl create secret docker-registry my-registry-secret \
  --docker-server=private-registry.example.com \
  --docker-username=testuser \
  --docker-password=testpass \
  --docker-email=test@example.com

# Check secret
kubectl get secret my-registry-secret -o yaml
```{{exec}}

Create a registry secret for authenticated pulls.
