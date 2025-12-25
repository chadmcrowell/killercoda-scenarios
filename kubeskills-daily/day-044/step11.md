## Step 11: Check pod resource utilization percentage

```bash
POD_CPU_USAGE=$(kubectl top pod guaranteed --no-headers | awk '{print $2}')
POD_CPU_REQUEST=$(kubectl get pod guaranteed -o jsonpath='{.spec.containers[0].resources.requests.cpu}')
POD_CPU_LIMIT=$(kubectl get pod guaranteed -o jsonpath='{.spec.containers[0].resources.limits.cpu}')

echo "CPU Usage: $POD_CPU_USAGE"
echo "CPU Request: $POD_CPU_REQUEST"
echo "CPU Limit: $POD_CPU_LIMIT"
```{{exec}}

Compare usage against requests and limits to see headroom.
