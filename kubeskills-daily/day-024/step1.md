## Step 1: Check current kube-proxy mode

Check the kube-proxy pods and their startup logs to see which mode is active:

```bash
kubectl get pods -n kube-system -l k8s-app=kube-proxy
kubectl logs -n kube-system -l k8s-app=kube-proxy --tail=50 | grep -i "mode\|using\|proxier"
```{{exec}}

Confirm by counting iptables KUBE-* chains (many chains = iptables mode is active):

```bash
iptables -t nat -L | grep -c "^Chain KUBE"
```{{exec}}

See which mode (iptables/ipvs/userspace) is configured.
