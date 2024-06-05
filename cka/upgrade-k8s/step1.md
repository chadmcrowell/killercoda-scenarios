Run the appropriate command to check the current version of the API server, controller manager, scheduler, kube-proxy, CoreDNS, and etcd.

The output should look similar to the following:
```bash
COMPONENT                 NODE           CURRENT    TARGET
kube-apiserver            controlplane   v1.30.0    v1.30.1
kube-controller-manager   controlplane   v1.30.0    v1.30.1
kube-scheduler            controlplane   v1.30.0    v1.30.1
kube-proxy                               1.30.0     v1.30.1
CoreDNS                                  v1.11.1    v1.11.1
etcd                      controlplane   3.5.12-0   3.5.12-0
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
