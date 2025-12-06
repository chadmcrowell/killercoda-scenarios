## Step 11: Check kube-proxy sync errors

```bash
kubectl logs -n kube-system -l k8s-app=kube-proxy --tail=50 | grep -i error
```{{exec}}

Look for sync failures (iptables/ipvs), endpoint list errors, or node lookup errors.
