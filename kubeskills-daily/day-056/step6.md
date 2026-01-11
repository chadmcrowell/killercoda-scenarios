## Step 6: Test scheduler back-off

```bash
# Create impossible-to-schedule pod
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: impossible-pod
  namespace: capacity-test
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        cpu: "100000m"  # 100 CPUs!
        memory: "1Ti"
EOF

# Check events
sleep 30
kubectl describe pod impossible-pod -n capacity-test | grep -A 20 "Events:"
```

Scheduler backs off after repeated failures.
