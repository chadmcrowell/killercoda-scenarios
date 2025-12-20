## Step 1: Check CoreDNS pods

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl get service -n kube-system kube-dns
```{{exec}}

Verify CoreDNS pods and service are present before breaking DNS.
