## Step 8: Debug node directly

```bash
NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')

kubectl debug node/$NODE -it --image=ubuntu
```{{exec}}

Inside the node debug container you can chroot to the host filesystem:

```bash
chroot /host
ps aux | head -20
tail /var/log/syslog | grep kubelet || true
exit
```{{exec}}

Exit the container to leave node debug session.
