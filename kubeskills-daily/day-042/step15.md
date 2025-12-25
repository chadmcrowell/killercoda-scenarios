## Step 15: Debug missing logs

```bash
kubectl exec logger -- sh -c 'echo "Direct log line"'
kubectl logs logger --tail=5

kubectl logs -n logging -l app=fluent-bit --tail=100 | grep logger || true
kubectl logs -n logging -l app=fluent-bit --tail=200 | grep -i error || true
kubectl exec -n logging -l app=fluent-bit -- ls -lh /fluent-bit/tail/ 2>/dev/null || echo "No tail buffer"
```{{exec}}

Check the app logs, Fluent Bit output, errors, and tail buffers to locate missing entries.
