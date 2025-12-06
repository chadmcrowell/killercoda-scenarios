## Step 3: Flood API server with requests

```bash
for i in $(seq 1 100); do
  kubectl get pods > /dev/null 2>&1 &
done
wait
echo "Burst complete"
```{{exec}}

```bash
kubectl get pods 2>&1 | grep -i "too many"
```{{exec}}

Look for HTTP 429 Too Many Requests responses.
