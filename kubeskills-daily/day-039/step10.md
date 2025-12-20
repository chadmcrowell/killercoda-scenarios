## Step 10: Test resource quota exhaustion

```bash
kubectl create namespace resource-test

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: mem-quota
  namespace: resource-test
spec:
  hard:
    requests.memory: "1Gi"
    limits.memory: "2Gi"
EOF
```{{exec}}

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: exceed-quota
  namespace: resource-test
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        memory: "2Gi"
      limits:
        memory: "2Gi"
EOF
```{{exec}}

This should fail with a quota exceeded error.
