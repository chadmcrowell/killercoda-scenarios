## Step 14: Test request timeout

```bash
kubectl get pods --request-timeout=1s 2>&1 || echo "Timeout!"
kubectl get pods --request-timeout=30s
```{{exec}}

Request timeout controls how long kubectl waits for a response.
