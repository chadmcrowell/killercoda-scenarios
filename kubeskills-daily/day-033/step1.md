## Step 1: Install Istio

```bash
# Download Istio
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.20.0 sh -
cd istio-1.20.0
export PATH=$PWD/bin:$PATH

# Install Istio
istioctl install --set profile=demo -y

# Label namespace for injection
kubectl label namespace default istio-injection=enabled
```{{exec}}

Installs Istio demo profile and enables sidecar injection in default namespace.
