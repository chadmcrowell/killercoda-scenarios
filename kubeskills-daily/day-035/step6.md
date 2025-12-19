## Step 6: Fix - remove init container from one service

```bash
kubectl delete deployment service-a

cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-a
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-a
  template:
    metadata:
      labels:
        app: service-a
    spec:
      # No init container - break the cycle!
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=Service A"]
        ports:
        - containerPort: 5678
EOF
```{{exec}}

Service A now starts, letting Service B's init container complete and the deadlock resolves.
