## Step 6: Test DNS resolution in pods

```bash
kubectl exec nettest-1 -- nslookup kubernetes.default
kubectl exec nettest-1 -- cat /etc/resolv.conf
```{{exec}}

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
```{{exec}}

Confirm CoreDNS is running and pods resolve service names.
