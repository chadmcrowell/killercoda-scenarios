## Step 12: Test metrics for multi-container pods

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: multi-container
spec:
  containers:
  - name: app1
    image: polinux/stress
    command: ["stress"]
    args: ["--cpu", "1"]
    resources:
      requests:
        cpu: "50m"
      limits:
        cpu: "100m"
  - name: app2
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "100M"]
    resources:
      requests:
        memory: "64Mi"
      limits:
        memory: "128Mi"
EOF
```{{exec}}

```bash
kubectl top pod multi-container --containers
```{{exec}}

See per-container metrics in a multi-container pod.
