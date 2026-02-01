## Step 13: Test missing instrumentation

```bash
# Deploy app without metrics
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: uninstrumented
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'while true; do echo Working; sleep 10; done']
EOF

kubectl wait --for=condition=Ready pod uninstrumented --timeout=60s

echo "Without instrumentation:"
echo "- No custom metrics"
echo "- Can't measure business KPIs"
echo "- Only infrastructure metrics"
echo "- Hard to correlate with issues"
```{{exec}}

Applications without instrumentation limit observability.
