Now for the safe “oh-no!” moment.  

We’ll *temporarily* hide the API server’s TLS private key.

---

## Watch kubelet logs in a second terminal

```bash
sudo journalctl -u kubelet -f
Move the key out of the way
```bash
sudo mv /etc/kubernetes/pki/apiserver.key /etc/kubernetes/pki/apiserver.key.bak
sleep 3
```

Test connectivity

```bash
kubectl get nodes
```

You should see it fail or hang. In your kubelet logs, you’ll see the API server static Pod fail to start.

Restore the key
```bash
sudo mv /etc/kubernetes/pki/apiserver.key.bak /etc/kubernetes/pki/apiserver.key
sleep 5
```

Verify recovery

```bash
kubectl get --raw='/readyz?verbose' | head
kubectl get nodes
```

🎯 Lesson learned: The API server can’t run without its TLS key. `/etc/kubernetes/pki` really is the control plane’s crown jewels.
