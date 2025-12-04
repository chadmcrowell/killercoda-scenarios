## Step 5: Compare with readiness probes

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: readiness-test
  labels:
    app: web
spec:
  containers:
  - name: app
    image: busybox:1.36.1
    command: ["/bin/sh", "-c", "sleep 10 && mkdir -p /www && echo 'Ready' > /www/index.html && httpd -f -p 8080 -h /www"]
    ports:
    - containerPort: 8080
    readinessProbe:
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 2
      periodSeconds: 3
      timeoutSeconds: 1
      failureThreshold: 2
    livenessProbe:
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 30
      periodSeconds: 10
      timeoutSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
EOF
```{{exec}}

```bash
kubectl get endpoints web-svc -w
```{{exec}}

Readiness failures drop the pod from service endpoints without restarting it.
