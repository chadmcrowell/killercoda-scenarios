## Step 10: Test init container with retries

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-retry
spec:
  restartPolicy: OnFailure
  initContainers:
  - name: retry-init
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      if [ -f /tmp/success ]; then
        echo "Success file exists, continuing"
        exit 0
      else
        echo "First attempt, failing"
        touch /tmp/success
        exit 1
      fi
    volumeMounts:
    - name: state
      mountPath: /tmp
  containers:
  - name: app
    image: nginx
  volumes:
  - name: state
    emptyDir: {}
EOF
```{{exec}}

```bash
kubectl get pod init-retry -w
kubectl describe pod init-retry | grep -A 10 Events
```{{exec}}

Observe the init container retry and eventually succeed due to persisted state.
