## Step 6: Trigger OOMKill

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: oom-test
spec:
  containers:
  - name: stress
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "600M"]
    resources:
      requests:
        memory: "256Mi"
      limits:
        memory: "512Mi"
EOF
```{{exec}}

```bash
kubectl get pod oom-test -w
kubectl describe pod oom-test | grep -A 5 "Last State"
```{{exec}}

Allocation above the limit triggers OOMKilled.
