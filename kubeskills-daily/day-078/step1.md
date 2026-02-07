## Step 1: Test basic non-privileged container

```bash
# Normal container with restrictions
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: restricted-pod
spec:
  containers:
  - name: app
    image: ubuntu
    command: ['sleep', '3600']
    securityContext:
      allowPrivilegeEscalation: false
      runAsNonRoot: true
      runAsUser: 1000
      capabilities:
        drop: ["ALL"]
      readOnlyRootFilesystem: true
EOF

kubectl wait --for=condition=Ready pod restricted-pod --timeout=60s

# Try to access host resources (blocked)
kubectl exec restricted-pod -- ls /host 2>&1 || echo "Cannot access host (good!)"
```{{exec}}

A properly restricted container cannot access host resources - this is the baseline secure configuration.
