## Step 2: Test normal connectivity

```bash
POD_0=$(kubectl get pod split-test-0 -o jsonpath='{.status.podIP}')
POD_1=$(kubectl get pod split-test-1 -o jsonpath='{.status.podIP}')
POD_2=$(kubectl get pod split-test-2 -o jsonpath='{.status.podIP}')

echo "Pod IPs: $POD_0, $POD_1, $POD_2"

kubectl exec split-test-0 -- curl -m 2 http://$POD_1 > /dev/null 2>&1 && echo "0→1: OK"
kubectl exec split-test-1 -- curl -m 2 http://$POD_2 > /dev/null 2>&1 && echo "1→2: OK"
```{{exec}}

Baseline connectivity between pods.
