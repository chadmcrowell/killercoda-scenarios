## Step 2: Check kubelet eviction thresholds

```bash
kubectl get configmap kubelet-config -n kube-system -o yaml 2>/dev/null || echo "Kubelet config not in ConfigMap"
```{{exec}}

Defaults (if unset): memory.available < 100Mi, nodefs.available < 10%, imagefs.available < 15%.
