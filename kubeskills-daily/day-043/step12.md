## Step 12: Debug missing spans

```bash
kubectl logs -l app=service-a --tail=50 | grep -i trace || true
kubectl logs -n tracing -l app=otel-collector --tail=100
kubectl logs -n tracing -l app=jaeger --tail=100
curl -s "http://localhost:16686/api/traces?service=service-a&limit=10" | jq .
```{{exec}}

Check senders, collector, storage, and Jaeger API to find span gaps.
