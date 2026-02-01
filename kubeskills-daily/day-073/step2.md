## Step 2: Set up ResourceQuotas per tenant

```bash
# Create quota for each tenant
for tenant in team-a team-b team-c; do
  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: tenant-quota
  namespace: $tenant
spec:
  hard:
    requests.cpu: "4"
    requests.memory: "8Gi"
    limits.cpu: "8"
    limits.memory: "16Gi"
    pods: "20"
    services: "10"
    persistentvolumeclaims: "5"
EOF
done

# Check quotas
kubectl get resourcequota -A
```{{exec}}

ResourceQuotas limit resources per namespace.
