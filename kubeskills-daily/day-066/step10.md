## Step 10: Test object count quota

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: object-count
  namespace: quota-test
spec:
  hard:
    count/deployments.apps: "3"
    count/services: "5"
    count/secrets: "10"
EOF

# Check quota
kubectl describe resourcequota object-count -n quota-test
```{{exec}}

Apply object count limits and review usage.
