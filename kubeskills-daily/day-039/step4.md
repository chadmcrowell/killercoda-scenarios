## Step 4: Deploy Guaranteed pod (requests = limits)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: guaranteed-pod
  labels:
    qos: guaranteed
spec:
  containers:
  - name: app
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "100M"]
    resources:
      requests:
        memory: "128Mi"
        cpu: "100m"
      limits:
        memory: "128Mi"
        cpu: "100m"
EOF
```{{exec}}

```bash
kubectl get pod guaranteed-pod -o jsonpath='{.status.qosClass}'; echo ""
```{{exec}}

QoS class should be Guaranteed.
