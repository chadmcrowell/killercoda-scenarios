## Step 15: Test mesh upgrade scenario

```bash
# Simulate mesh version mismatch
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: old-sidecar
  namespace: mesh-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: old-version
  template:
    metadata:
      labels:
        app: old-version
      annotations:
        sidecar.istio.io/proxyImage: "istio/proxyv2:1.16.0"
    spec:
      containers:
      - name: app
        image: nginx
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: new-sidecar
  namespace: mesh-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: new-version
  template:
    metadata:
      labels:
        app: new-version
      annotations:
        sidecar.istio.io/proxyImage: "istio/proxyv2:1.20.0"
    spec:
      containers:
      - name: app
        image: nginx
EOF

echo "Version mismatch can cause:"
echo "- Protocol incompatibilities"
echo "- Feature flag differences"
echo "- Certificate validation issues"
```{{exec}}

Simulate sidecar version skew during upgrades.
