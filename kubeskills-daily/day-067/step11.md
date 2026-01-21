## Step 11: Test sidecar containers (K8s 1.28+)

```bash
# Check if sidecar feature is available
kubectl version --short | grep "Server Version"

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: with-sidecar
spec:
  initContainers:
  - name: init-setup
    image: busybox
    command: ['sh', '-c', 'echo Init complete']
  - name: log-collector
    image: busybox
    restartPolicy: Always  # Makes this a sidecar (if supported)
    command:
    - sh
    - -c
    - |
      while true; do
        echo "Collecting logs..."
        sleep 10
      done
  containers:
  - name: app
    image: nginx
EOF

# Sidecar runs alongside main container
sleep 15
kubectl get pod with-sidecar -o jsonpath='{.status.initContainerStatuses[].name}'
echo ""
kubectl logs with-sidecar -c log-collector --tail=5 2>/dev/null || echo "Sidecar feature may not be available"
```{{exec}}

Test the new sidecar init container behavior (if supported).
