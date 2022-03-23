
Now that we have a valid snapshot of etcd, let's modify the cluster state in order to simulate a disaster

Let's delete the _kube-proxy_ daemonset, which is in the _kube-system_ namespace

`k delete ds kube-proxy -n kube-system`

We can verify that this daemonset no longer exists with the command

`k get ds -A`

Oh no! How do we get our _kube-proxy_ daemonset back? Good thing we have a backup! 

Click next to restore our beloved _kube-proxy_ daemonset from our snapshot backup