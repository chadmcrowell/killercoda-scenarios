## Step 12: Test affinity constraints

```bash
# Create pod with impossible affinity
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: affinity-fail
  namespace: capacity-test
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: nonexistent-label
            operator: In
            values:
            - "true"
  containers:
  - name: app
    image: nginx
EOF

# Check why not scheduled
kubectl describe pod affinity-fail -n capacity-test | grep -A 10 "Events:"
```

No nodes match the required affinity rules.
