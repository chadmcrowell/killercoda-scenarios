## Step 9: Test init container resource limits

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-resources
spec:
  initContainers:
  - name: resource-intensive-init
    image: busybox
    command: ['sh', '-c', 'echo Running intensive init; sleep 5']
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
      limits:
        cpu: "200m"
        memory: "256Mi"
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
EOF

kubectl wait --for=condition=Ready pod init-resources --timeout=60s
```{{exec}}

Ensure init containers respect resource limits.
