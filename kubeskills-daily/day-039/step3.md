## Step 3: Deploy Burstable pod (requests < limits)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: burstable-pod
  labels:
    qos: burstable
spec:
  containers:
  - name: app
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "100M"]
    resources:
      requests:
        memory: "64Mi"
        cpu: "100m"
      limits:
        memory: "256Mi"
        cpu: "500m"
EOF
```{{exec}}

```bash
kubectl get pod burstable-pod -o jsonpath='{.status.qosClass}'; echo ""
```{{exec}}

QoS class should be Burstable.
