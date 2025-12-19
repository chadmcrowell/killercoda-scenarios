## Step 1: Create Service A (depends on Service B)

```bash
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
      initContainers:
      - name: wait-for-service-b
        image: busybox
        command: ['sh', '-c']
        args:
        - |
          echo "Waiting for service-b..."
          until nslookup service-b; do
            echo "service-b not ready yet"
            sleep 2
          done
          echo "service-b DNS resolved, checking endpoint..."
          until wget -O- http://service-b:80; do
            echo "service-b not responding yet"
            sleep 2
          done
          echo "service-b is ready!"
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=Service A"]
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: service-a
spec:
  selector:
    app: service-a
  ports:
  - port: 80
    targetPort: 5678
EOF
```{{exec}}

Service A blocks until Service B responds, creating the circular wait.
