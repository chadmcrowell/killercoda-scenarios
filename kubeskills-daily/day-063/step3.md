## Step 3: Check CoreDNS configuration

```bash
# Get CoreDNS ConfigMap
kubectl get configmap -n kube-system coredns -o yaml

# Show Corefile
kubectl get configmap -n kube-system coredns -o jsonpath='{.data.Corefile}'
echo ""
```{{exec}}

Inspect the CoreDNS Corefile for plugins and forwarding rules.
