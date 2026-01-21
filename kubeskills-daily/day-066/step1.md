## Step 1: Create namespace with ResourceQuota

```bash
kubectl create namespace quota-test

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: basic-quota
  namespace: quota-test
spec:
  hard:
    requests.cpu: "2"
    requests.memory: "2Gi"
    limits.cpu: "4"
    limits.memory: "4Gi"
    pods: "5"
    services: "3"
    persistentvolumeclaims: "2"
    configmaps: "5"
    secrets: "5"
EOF

# Check quota
kubectl describe resourcequota basic-quota -n quota-test
```{{exec}}

Create a namespace and set baseline resource limits.
