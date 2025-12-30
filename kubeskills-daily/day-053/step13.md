## Step 13: Simulate healing

```bash
kubectl delete networkpolicy --all
sleep 10
kubectl exec split-test-0 -- curl -m 2 http://split-test-1.split-test-svc > /dev/null 2>&1 && echo "Partition healed!"
```{{exec}}

Remove policies and confirm connectivity returns.
