## Step 1: Create a StatefulSet with slow-starting pods

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        command: ['sh', '-c', 'echo "Pod starting..."; sleep 30; exec nginx -g "daemon off;"']
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 35
          periodSeconds: 5
EOF
```{{exec}}

Give each pod time to start; the `sleep 30` ensures the controller strictly waits for readiness before creating the next ordinal.
