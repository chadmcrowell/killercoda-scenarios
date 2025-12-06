## Step 12: Check CNI plugin capabilities

```bash
kubectl get pods -n kube-system -o wide | grep -E "calico|cilium|flannel|weave"
```{{exec}}

Different CNI plugins offer different features (NetworkPolicy support, overlays, encryption, eBPF).
