## Step 9: Test init container failure blocking main

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-fail
spec:
  initContainers:
  - name: failing-init
    image: busybox
    command: ['sh', '-c', 'echo "Failing intentionally"; exit 1']
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl get pod init-fail
```{{exec}}

The init container CrashLoopBackOff prevents the main container from ever starting.
