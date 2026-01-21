## Step 4: Test init container crash loop

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-crashloop
spec:
  initContainers:
  - name: crash-init
    image: busybox
    command: ['sh', '-c', 'echo Crashing...; exit 1']
  containers:
  - name: app
    image: nginx
EOF

# Watch restart count increase
watch -n 2 "kubectl get pod init-crashloop"
```{{exec}}

Observe repeated init container restarts.
