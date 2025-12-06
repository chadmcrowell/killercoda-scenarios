## Step 12: Check kubelet image pull logs

On a node you can inspect the kubelet/container runtime logs:

```bash
# journalctl -u kubelet | grep -i "image pull"
# journalctl -u containerd | grep -i pull
```

Cluster-wide events also show pull errors:

```bash
kubectl get events --all-namespaces --sort-by='.lastTimestamp' | grep -i image
```{{exec}}
