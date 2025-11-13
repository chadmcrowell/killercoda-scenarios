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
    image: hashicorp/http-echo
    args:
    - "-text=Slow response"
    - "-listen=:8080"
    ports:
    - containerPort: 8080
    lifecycle:
      postStart:
        exec:
          command: ["/bin/sh", "-c", "sleep 10"]
    livenessProbe:
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 2
      periodSeconds: 3
      timeoutSeconds: 1
      failureThreshold: 2
EOF
```{{exec}}

Probe fires before the app is ready, guaranteeing failures.
