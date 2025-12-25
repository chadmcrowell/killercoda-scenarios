## Step 3: Fix with startupProbe

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: startup-probe-fixed
spec:
  containers:
  - name: app
    image: hashicorp/http-echo
    args: ["-text=Fixed", "-listen=:8080"]
    ports:
    - containerPort: 8080
    lifecycle:
      postStart:
        exec:
          command: ['sh', '-c', 'sleep 30']
    startupProbe:
      httpGet:
        path: /
        port: 8080
      periodSeconds: 5
      failureThreshold: 10
    livenessProbe:
      httpGet:
        path: /
        port: 8080
      periodSeconds: 10
      failureThreshold: 3
EOF
```{{exec}}

```bash
kubectl get pod startup-probe-fixed -w
```{{exec}}

Startup probe gives 50 seconds before liveness begins.
