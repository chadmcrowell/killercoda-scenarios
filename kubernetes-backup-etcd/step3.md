
In order to restore the Kubernetes cluster to the previous state (when we took the backup), we can use the **etcdctl** command-line tool again!

Let's restore from the 'snapshot' file in our current directory. It's a local file, so we don't need any authentication.

> 🔥TIP: The kubelet runs the etcd pod directly (without kube-scheduler) and picks up the manifest in `/etc/kubernetes/manifests/etcd.yaml`

We can use the `etcdctl snapshot restore` command to restore from our snapshot, and use the `--data-dir` flag to place it in the same directory as the current etcd member.

`etcdctl snapshot restore snapshot --data-dir /var/lib/etcd-restore`

Finally, we'll need to update the manifest for etcd and tell it to get it's data from that restore operation we just did. I'll use sed to search for `/lib/etcd` and replace with `lib/etcd-restore` on line 76 in the etcd.yaml file.

`sed -i "76 s/lib\/etcd/lib\/etcd-restore/" /etc/kubernetes/manifests/etcd.yaml`

> 🛑 STOP 🛑 You will have to wait until the pod is restarted. This may take up to 2 minutes.

Let's see if the _kube-proxy_ daemonset has been restored with the command

`k get ds -A`

The output should look like this:
```bash
$ k get ds -A
NAMESPACE     NAME         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   kube-proxy   1         1         1       1            1           kubernetes.io/os=linux   16d
kube-system   weave-net    1         1         1       1            1           <none>                   16d
```