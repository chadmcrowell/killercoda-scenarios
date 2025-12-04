## Step 4: Fix the liveness probe

Delete the broken pod and recreate it with sane timings.

```bash
kubectl delete pod slow-app
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: slow-app-fixed
spec:
  containers:
  - name: app
    image: busybox:1.36.1
    command: ["/bin/sh", "-c", "sleep 10 && mkdir -p /www && echo 'Healthy now!' > /www/index.html && httpd -f -p 8080 -h /www"]
    ports:
    - containerPort: 8080
    livenessProbe:
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 15
      periodSeconds: 10
      timeoutSeconds: 5
      failureThreshold: 3
EOF
```{{exec}}

```bash
kubectl get pods slow-app-fixed -w
```{{exec}}

Pod should reach Running and stay there.
