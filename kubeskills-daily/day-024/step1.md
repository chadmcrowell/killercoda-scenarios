## Step 1: Check current kube-proxy mode

Check the kube-proxy DaemonSet configuration for the proxy mode:

```bash
kubectl get ds kube-proxy -n kube-system -o jsonpath='{.spec.template.spec.containers[0].args}' | tr ',' '\n'
```{{exec}}

Check the kube-proxy pods and their logs to see which mode is active:

```bash
kubectl get pods -n kube-system -l k8s-app=kube-proxy
kubectl logs -n kube-system -l k8s-app=kube-proxy --tail=20 | grep -i "mode\|using\|proxy"
```{{exec}}

See which mode (iptables/ipvs/userspace) is configured.
