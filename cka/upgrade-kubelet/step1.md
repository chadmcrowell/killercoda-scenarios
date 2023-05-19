Upgrade the kubelet to version 1.27.0 and verify that the kubelet has been upgraded.

**HINT:** We use the apt package manager to install in Ubuntu

<br>
<details><summary>Solution</summary>
<br>

```plain
# check the current version of kubelet
k get no
```{{exec}}

```plain
# install kubelet and pin it to version 1.27.0
# you can view this page from K8s docs during the exam: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# download the gpg key
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

```{{exec}}

```plain
# add to apt sources
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

```{{exec}}

```bash
# update package index and install kubelet version 1.27.0
sudo apt update
sudo apt install -y kubelet=1.27.0-00
```{{exec}}

```plain
# verify the version of kubelet has been upgraded to 1.27.0
k get no
```{{exec}}

</details>
