Run the command `kubeadm upgrade apply v1.27.0`{{copy}} to upgrade the control plane components to 1.27.0. 

Determine why you received the following message: 
```
Specified version to upgrade to "v1.27.0" is at least one minor release higher than the kubeadm minor release (27 > 26). Such an upgrade is not supported
```

Run the appropriate commands to resolve this problem and get your cluster upgraded to 1.27.0.

**HINT:** Check the version of kubeadm. You will realize that you can't upgrade past the current version of kubeadm.

<br>
<details><summary>Solution</summary>
<br>

```plain
# get the version of kubeadm
kubeadm version -o json | jq
```{{exec}}

```plain
# upgrade kubeadm to version 1.27.0
sudo apt install -y kubeadm=1.27.0-00
```{{exec}}

</details>
