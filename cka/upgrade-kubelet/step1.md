Upgrade the kubelet to version 1.34.2 and verify that the kubelet has been upgraded.

**HINT:** We use the apt package manager to install packages in Ubuntu

<br>
<details><summary>Solution</summary>
<br>

```bash
# check the current version of kubelet
k get no
```{{exec}}

```bash
# install kubelet and pin it to version 1.34.2
# you can view this page from K8s docs during the exam: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

sudo apt-get update

# Download the public signing key for the Kubernetes package repositories
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

```{{exec}}

```bash
# Add the appropriate Kubernetes apt repository. Please note that this repository have packages only for Kubernetes 1.34
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```{{exec}}

```bash
# update packages from local repo sources
sudo apt update
```

```bash
# update package index and install kubelet version 1.34.2
# optionally run apt-cache madison kubelet
# sudo apt-cache madison kubelet
sudo apt install -y kubelet=1.34.2-1.1
```{{exec}}

```bash
# verify the version of kubelet has been upgraded to 1.34.2
k get no
```{{exec}}

</details>
