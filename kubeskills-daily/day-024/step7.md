## Step 7: Check service IP allocation

```bash
kubectl get services -A -o wide | head -20
kubectl cluster-info dump | grep -m 1 service-cluster-ip-range
```{{exec}}

Services draw IPs from the service CIDR.
