## Step 13: Monitor API server CPU/memory

```bash
kubectl top pod -n kube-system -l component=kube-apiserver || true
kubectl logs -n kube-system -l component=kube-apiserver --tail=50 | grep -i "throttl\|limit\|reject" || true
```{{exec}}

Check resource usage and logs for throttling/rejections.
