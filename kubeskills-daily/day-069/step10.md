## Step 10: Test traffic mirroring/shadowing

```bash
# Simulate traffic shadowing concept
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: production
  namespace: mesh-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: prod
  template:
    metadata:
      labels:
        app: prod
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=Production"]
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: canary
  namespace: mesh-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: canary
  template:
    metadata:
      labels:
        app: canary
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=Canary (mirrored traffic)"]
EOF

echo "Traffic mirroring sends copy of live traffic to canary"
echo "Used for testing without impacting production"
```{{exec}}

Introduce the traffic mirroring concept.
