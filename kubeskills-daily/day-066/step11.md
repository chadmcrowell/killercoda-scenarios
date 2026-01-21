## Step 11: Test scope-based quota

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: besteffort-quota
  namespace: quota-test
spec:
  hard:
    pods: "2"
  scopes:
  - BestEffort  # Only applies to pods without resource requests/limits
EOF

# Create BestEffort pod (no requests/limits)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: besteffort-1
  namespace: quota-test
spec:
  containers:
  - name: app
    image: nginx
    resources: {}  # No requests or limits = BestEffort
EOF

# This counts against besteffort-quota, not basic-quota
kubectl describe resourcequota besteffort-quota -n quota-test
```{{exec}}

Limit only BestEffort pods with scoped quota.
