## Step 1: Check CoreDNS status

```bash
# Check CoreDNS pods
kubectl get pods -n kube-system -l k8s-app=kube-dns

# Check CoreDNS service
kubectl get svc -n kube-system kube-dns

# Get DNS service IP
DNS_IP=$(kubectl get svc -n kube-system kube-dns -o jsonpath='{.spec.clusterIP}')
echo "DNS Service IP: $DNS_IP"
```{{exec}}

Verify CoreDNS pods and the kube-dns service are running.
