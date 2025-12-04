## Step 6: Simulate startup probes for slow apps

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: slow-startup
spec:
  containers:
  - name: app
    image: busybox:1.36.1
    command: ["/bin/sh", "-c", "sleep 60 && mkdir -p /www && echo 'Finally started' > /www/index.html && httpd -f -p 8080 -h /www"]
    ports:
    - containerPort: 8080
    startupProbe:
      httpGet:
        path: /
        port: 8080
      periodSeconds: 5
      failureThreshold: 30
    livenessProbe:
      httpGet:
        path: /
        port: 8080
      periodSeconds: 10
      timeoutSeconds: 5
      failureThreshold: 3
EOF
```{{exec}}

Startup probes give up to 150s (30 * 5s) before liveness begins, perfect for JVM-scale boot times.
