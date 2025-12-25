## Step 9: Tune probe timing

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: tuned-probes
spec:
  containers:
  - name: app
    image: nginx
    ports:
    - containerPort: 80
    startupProbe:
      httpGet:
        path: /
        port: 80
      periodSeconds: 5
      failureThreshold: 30
    livenessProbe:
      httpGet:
        path: /
        port: 80
      periodSeconds: 10
      timeoutSeconds: 5
      failureThreshold: 3
    readinessProbe:
      httpGet:
        path: /
        port: 80
      periodSeconds: 2
      timeoutSeconds: 1
      failureThreshold: 1
      successThreshold: 1
EOF
```{{exec}}

Startup allows 150s max, liveness 30s to recover, readiness pulls pods fast.
