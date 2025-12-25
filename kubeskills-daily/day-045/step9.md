## Step 9: Debug CrashLoopBackOff pod

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: crashloop
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'echo "Starting..."; exit 1']
EOF
```{{exec}}

```bash
kubectl get pod crashloop
kubectl debug crashloop -it --copy-to=crashloop-debug --container=app --image=busybox -- sh
```{{exec}}

Override the failing command to inspect the CrashLoop container.
