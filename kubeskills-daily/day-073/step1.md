## Step 1: Create tenant namespaces

```bash
# Create three tenant namespaces
for tenant in team-a team-b team-c; do
  kubectl create namespace $tenant
  kubectl label namespace $tenant tenant=$tenant
done

# Check namespaces
kubectl get namespaces -L tenant
```{{exec}}

Tenant namespaces created with identifying labels.
