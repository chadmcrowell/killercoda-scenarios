Fix the issue by restarting kubelet:

```bash
sudo systemctl start kubelet
```{{exec}}

Verify:
```bash
sudo systemctl status kubelet -n 20
```{{exec}}

Now go back to the control plane and confirm the node is healthy:
```bash
exit
```

```
kubectl get nodes
```

✅ node01 should be back to Ready state.