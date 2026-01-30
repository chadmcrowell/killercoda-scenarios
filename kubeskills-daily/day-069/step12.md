## Step 12: Test observability without mesh

```bash
# Without service mesh, no automatic tracing
kubectl run trace-test -n mesh-demo --image=nginx

echo "Without service mesh:"
echo "- No automatic distributed tracing"
echo "- No service-to-service metrics"
echo "- No mutual TLS by default"
echo "- Manual observability instrumentation required"
```{{exec}}

Contrast observability with and without a mesh.
