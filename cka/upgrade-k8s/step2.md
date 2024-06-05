Run the command `kubeadm upgrade apply v1.30.1`{{exec}} to upgrade the control plane components to 1.30.1. 

Determine why you received the following message: 
```
Specified version to upgrade to "v1.30.1" is higher than the kubeadm version "v1.30.0". Upgrade kubeadm first using the tool you used to install kubeadm
```

Run the appropriate commands to resolve this problem and get your cluster upgraded to 1.30.1.

**HINT:** Check the version of kubeadm. You will realize that you can't upgrade past the current version of kubeadm.

<br>
<details><summary>Solution</summary>
<br>

```plain
# get the version of kubeadm
kubeadm version -o json | jq
```{{exec}}

```plain
# upgrade kubeadm to version 1.28.3
sudo apt install -y kubeadm=1.30.1-1.1
```{{exec}}

</details>

[Reference](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)
