#!/bin/bash

# Install Istio
curl -L https://istio.io/downloadIstio | sh -
# cd istio-*
# export PATH=$PWD/bin:$PATH

# Install with demo profile
istioctl install --set profile=demo -y

# Enable sidecar injection
kubectl label namespace default istio-injection=enabled