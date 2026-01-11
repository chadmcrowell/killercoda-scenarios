## Step 8: Test overcommitment

```bash
# Check total requests vs allocatable
kubectl describe nodes | grep -E "Allocatable:|Allocated resources:" -A 5

# Pods can use limits beyond requests (overcommit)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: overcommit-pod
  namespace: capacity-test
spec:
  containers:
  - name: app
    image: polinux/stress
    command: ["stress"]
    args: ["--cpu", "4"]
    resources:
      requests:
        cpu: "100m"  # Small request
      limits:
        cpu: "4000m"  # Large limit (overcommit)
EOF
```

Overcommitment allows CPU bursts but can cause throttling.
