## Install and Configure Helm Repository

In this step, you'll set up Helm repositories and verify the installation.

First, verify that Helm is installed and check the version:
```bash
helm version
```{{exec}}

Add the official nginx Helm repository:
```bash
helm repo add nginx-stable https://helm.nginx.com/stable
```{{exec}}

Update the repository to fetch the latest chart information:
```bash
helm repo update
```{{exec}}

Search for available nginx charts:
```bash
helm search repo nginx
```{{exec}}

Get detailed information about the nginx-ingress chart:
```bash
helm show chart nginx-stable/nginx-ingress
```{{exec}}

View the default values for this chart:
```bash
helm show values nginx-stable/nginx-ingress
```{{exec}}

List the configured repositories:
```bash
helm repo list
```{{exec}}