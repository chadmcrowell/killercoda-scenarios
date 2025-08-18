Now for the safe “oh-no!” moment.  

We’ll *temporarily* hide the API server’s TLS private key with this command:
```bash
sudo mv /etc/kubernetes/pki/apiserver.key /etc/kubernetes/pki/apiserver.key.bak
```

---

Now open `Tab 2` and run this command to follow the logs
```bash
sudo journalctl -u kubelet -f
```{{exec}}

Back in `Tab 1`, trigger the kubelet to restart the `kube-apiserver` static pod
```bash
sudo sed -i '1s/^/# trigger reload\n/' /etc/kubernetes/manifests/kube-apiserver.yaml
```{{exec}}

Delete the running apiserver container via `crictl`
```bash
sudo crictl ps | awk '/kube-apiserver/{print $1}' | xargs -r sudo crictl rm -f
```{{exec}}

Restart kubelet:
```bash
sudo systemctl restart kubelet
```{{exec}}

Test connectivity
```bash
kubectl get nodes
```{{exec}}

You should see it fail or hang. In your kubelet logs, you’ll see the API server static Pod fail to start.


Back in `Tab 2`, you should see the `journalctl` logs flowing. You should see the apiserver container crash/loop with TLS file errors.


Now, let's restore the key back in `Tab 1`
```bash
sudo mv /etc/kubernetes/pki/apiserver.key.bak /etc/kubernetes/pki/apiserver.key
```{{exec}}

Verify recovery
```bash
kubectl get --raw='/readyz?verbose' | head
```{{exec}}

```bash
kubectl get nodes
```{{exec}}

🎯 Lesson learned: The API server can’t run without its TLS key. `/etc/kubernetes/pki` really is the control plane’s crown jewels.
