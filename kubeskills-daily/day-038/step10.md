## Step 10: Inspect CoreDNS ConfigMap

```bash
kubectl get configmap coredns -n kube-system -o yaml
```{{exec}}

Optionally add custom hosts in the Corefile, then reload CoreDNS:

```bash
kubectl edit configmap coredns -n kube-system
# Add under ".:53" section:
#   hosts {
#     192.168.1.100 custom.example.com
#     fallthrough
#   }

kubectl rollout restart deployment coredns -n kube-system
kubectl wait --for=condition=Ready pods -l k8s-app=kube-dns -n kube-system --timeout=60s
```{{exec}}

Custom host entries will resolve via CoreDNS once pods restart.
