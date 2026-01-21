## Step 13: Test quota for multiple namespaces

```bash
# Create another namespace with quota
kubectl create namespace quota-test-2

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: basic-quota
  namespace: quota-test-2
spec:
  hard:
    requests.cpu: "1"
    requests.memory: "1Gi"
    pods: "3"
EOF

# Quotas are per-namespace
kubectl run test -n quota-test-2 --image=nginx \
  --requests="cpu=100m,memory=128Mi" \
  --limits="cpu=200m,memory=256Mi"

kubectl describe resourcequota basic-quota -n quota-test-2
```{{exec}}

Verify quotas apply independently per namespace.
