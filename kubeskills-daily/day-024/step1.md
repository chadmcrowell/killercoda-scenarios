## Step 1: Check current kube-proxy mode

```bash
kubectl get configmap kube-proxy -n kube-system -o yaml | grep mode
```{{exec}}

```bash
kubectl get pods -n kube-system -l k8s-app=kube-proxy
kubectl logs -n kube-system -l k8s-app=kube-proxy --tail=20
```{{exec}}

See which mode (iptables/ipvs/userspace) is configured.
