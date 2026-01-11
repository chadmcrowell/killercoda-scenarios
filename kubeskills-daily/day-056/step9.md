## Step 9: Test resource quotas

```bash
# Create ResourceQuota
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: capacity-quota
  namespace: capacity-test
spec:
  hard:
    requests.cpu: "5"
    requests.memory: "10Gi"
    limits.cpu: "10"
    limits.memory: "20Gi"
    pods: "20"
EOF

# Check quota usage
kubectl describe resourcequota capacity-quota -n capacity-test
```

ResourceQuotas cap total namespace usage.
