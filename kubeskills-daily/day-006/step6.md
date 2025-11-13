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
    image: hashicorp/http-echo
    args:
    - "-text=Finally started"
    - "-listen=:8080"
    lifecycle:
      postStart:
        exec:
          command: ["/bin/sh", "-c", "sleep 60"]
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
