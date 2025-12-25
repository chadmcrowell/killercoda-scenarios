## Step 2: Deploy app with slow startup (liveness kills it)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: slow-startup
spec:
  containers:
  - name: app
    image: hashicorp/http-echo
    args: ["-text=Slow starter", "-listen=:8080"]
    ports:
    - containerPort: 8080
    lifecycle:
      postStart:
        exec:
          command: ['sh', '-c', 'sleep 30']
    livenessProbe:
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 5
      failureThreshold: 3
EOF
```{{exec}}

```bash
kubectl get pod slow-startup -w
```{{exec}}

Liveness fires before startup completes, causing restarts.
