## Step 6: Test with multiple services

```bash
for i in $(seq 1 10); do
  kubectl create deployment test-$i --image=nginx --port=80
  kubectl expose deployment test-$i --port=80
done
kubectl exec iptables-viewer -- iptables-save | wc -l
```{{exec}}

Rule count grows quickly as services increase.
