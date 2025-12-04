Run the command `kubeadm upgrade apply v1.34.2`{{exec}} to upgrade the control plane components to 1.34.2. 

Determine why you received the following message: 
```
Specified version to upgrade to "v1.34.2" is higher than the kubeadm version "v1.34.1". Upgrade kubeadm first using the tool you used to install kubeadm
```

Run the appropriate commands to resolve this problem and get your cluster upgraded to 1.34.2.

**HINT:** Check the version of kubeadm. You will realize that you can't upgrade past the current version of kubeadm.

**🔥 HOT TIP:** Use apt-cache to find the appropriate packages:
```bash
apt-cache madison kubelet
apt-cache madison kubectl
apt-cache madison kubeadm
```{{exec}}

<br>
<details><summary>Solution</summary>
<br>

```plain
# get the version of kubeadm
kubeadm version -o json | jq
```{{exec}}

```plain
# upgrade kubeadm to version 1.34.2
sudo apt install -y kubeadm=1.34.2-1.1
```{{exec}}

</details>

[Reference](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)
