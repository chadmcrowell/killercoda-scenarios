## Step 9: Test MTU issues

```bash
kubectl exec nettest-1 -- ip link show eth0 | grep mtu
kubectl exec nettest-1 -- ping -M do -s 1400 -c 3 $(kubectl get pod nettest-2 -o jsonpath='{.status.podIP}')
kubectl exec nettest-1 -- ping -M do -s 1472 -c 3 $(kubectl get pod nettest-2 -o jsonpath='{.status.podIP}')
```{{exec}}

Large packets may fail if MTU is misconfigured.
