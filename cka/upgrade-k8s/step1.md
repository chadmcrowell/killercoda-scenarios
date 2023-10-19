Run the appropriate command to check the current version of the API server, controller manager, scheduler, kube-proxy, CoreDNS, and etcd.

The output should look similar to the following:
```bash
COMPONENT                 CURRENT   TARGET
kube-apiserver            v1.28.1   v1.28.3
kube-controller-manager   v1.28.1   v1.28.3
kube-scheduler            v1.28.1   v1.28.3
kube-proxy                v1.28.1   v1.28.3
CoreDNS                   v1.10.1   v1.10.1
etcd                      3.5.9-0   3.5.9-0
```

**HINT:** try `kubeadm -h` for help with command options

<br>
<details><summary>Solution</summary>
<br>

```plain
# check the current and target version of control plane components
kubeadm upgrade plan
```{{exec}}


</details>
