## Step 14: Simulate registry downtime

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: registry-timeout
spec:
  containers:
  - name: app
    image: nonexistent-registry.example.com:12345/app:latest
EOF
```{{exec}}

```bash
kubectl describe pod registry-timeout | grep -A 5 Events
```{{exec}}

Expect connection timeout errors instead of auth failures.
