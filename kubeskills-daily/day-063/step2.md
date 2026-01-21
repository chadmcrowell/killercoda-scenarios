## Step 2: Test normal DNS resolution

```bash
# Deploy test pod
kubectl run dns-test --image=busybox --restart=Never --command -- sleep 3600

kubectl wait --for=condition=Ready pod dns-test --timeout=60s

# Check resolv.conf
kubectl exec dns-test -- cat /etc/resolv.conf

# Test service DNS
kubectl create deployment nginx --image=nginx --replicas=2
kubectl expose deployment nginx --port=80

kubectl exec dns-test -- nslookup nginx.default.svc.cluster.local
```{{exec}}

Confirm pod DNS config and service name resolution works.
