## Step 5: Test DNS resolution during partition

```bash
kubectl exec split-test-0 -- nslookup split-test-1.split-test-svc.default.svc.cluster.local
kubectl exec split-test-0 -- curl -m 2 http://split-test-1.split-test-svc 2>&1 || echo "DNS works but connection fails"
```{{exec}}

DNS still resolves; traffic fails due to the partition.
