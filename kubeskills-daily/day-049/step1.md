## Step 1: Install Velero CLI

```bash
wget https://github.com/vmware-tanzu/velero/releases/download/v1.12.0/velero-v1.12.0-linux-amd64.tar.gz

# Note: network downloads may not work in restricted environments

```{{exec}}|skip{{sandbox}}

```bash
tar -xvf velero-v1.12.0-linux-amd64.tar.gz
sudo mv velero-v1.12.0-linux-amd64/velero /usr/local/bin/
velero version --client-only
```{{exec}}

Install the Velero CLI locally.
