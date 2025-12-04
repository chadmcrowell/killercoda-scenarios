## Step 1: Deploy a slow-starting pod with a bad liveness probe

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: slow-app
spec:
  containers:
  - name: app
    image: busybox:1.36.1
    command: ["/bin/sh", "-c", "sleep 10 && mkdir -p /www && echo 'Slow response' > /www/index.html && httpd -f -p 8080 -h /www"]
    ports:
    - containerPort: 8080
    livenessProbe:
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 2
      periodSeconds: 3
      timeoutSeconds: 1   # Too aggressive!
      failureThreshold: 2
EOF
```{{exec}}

Probe fires before the app is ready, guaranteeing failures.
