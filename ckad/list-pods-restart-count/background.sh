#!/bin/sh

# Prepare the lab environment before the learner starts.
set -euo pipefail

NAMESPACE="session283884"
DEPLOYMENT="demo-app"

kubectl get namespace "${NAMESPACE}" >/dev/null 2>&1 || \
kubectl create namespace "${NAMESPACE}"

cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-app
  namespace: session283884
spec:
  replicas: 3
  selector:
    matchLabels:
      app: demo-app
  template:
    metadata:
      labels:
        app: demo-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF
