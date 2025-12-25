## Step 1: Deploy app with aggressive liveness probe (restart loop)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: aggressive-probe
spec:
  containers:
  - name: app
    image: hashicorp/http-echo
    args: ["-text=Hello", "-listen=:8080"]
    ports:
    - containerPort: 8080
    livenessProbe:
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 1
      periodSeconds: 2
      timeoutSeconds: 1
      failureThreshold: 1
EOF
```{{exec}}

```bash
kubectl get pod aggressive-probe -w
```{{exec}}

Probe restarts the pod after a single failure; brief hiccups cause a loop.
