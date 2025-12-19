## Step 2: Create Service B (depends on Service A)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-b
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-b
  template:
    metadata:
      labels:
        app: service-b
    spec:
      initContainers:
      - name: wait-for-service-a
        image: busybox
        command: ['sh', '-c']
        args:
        - |
          echo "Waiting for service-a..."
          until nslookup service-a; do
            echo "service-a not ready yet"
            sleep 2
          done
          echo "service-a DNS resolved, checking endpoint..."
          until wget -O- http://service-a:80; do
            echo "service-a not responding yet"
            sleep 2
          done
          echo "service-a is ready!"
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=Service B"]
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: service-b
spec:
  selector:
    app: service-b
  ports:
  - port: 80
    targetPort: 5678
EOF
```{{exec}}

Service B waits on Service A, so the circular dependency is complete.
