## Step 7: Test init container with timeout

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-timeout-test
spec:
  initContainers:
  - name: wait-with-timeout
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      echo "Waiting up to 30 seconds..."
      timeout 30 sh -c 'until nslookup nonexistent-service; do sleep 2; done' || {
        echo "Timeout reached, continuing anyway"
        exit 0
      }
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl logs init-timeout-test -c wait-with-timeout
```{{exec}}

Check the init container logs to see the timeout fire and the pod continue.
