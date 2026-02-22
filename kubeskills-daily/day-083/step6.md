## Step 6: Test headless service requirement

```bash
kubectl delete service nginx-headless

sleep 5
```{{exec}}

```bash
kubectl run dns-fail-test --rm -i --image=busybox --restart=Never -- \
  nslookup web-0.nginx-headless.default.svc.cluster.local 2>&1 || echo "DNS resolution failed!"

echo ""
echo "Without headless service:"
echo "- Pod DNS names don't resolve"
echo "- Stable network identity broken"
echo "- Database cluster can't communicate"
```{{exec}}

Without a headless service, pod DNS names stop resolving — any clustered application relying on stable peer addresses (like etcd or Cassandra) breaks immediately.
