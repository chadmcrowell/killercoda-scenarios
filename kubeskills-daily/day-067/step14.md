## Step 14: Test init container probes

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-with-probe
spec:
  initContainers:
  - name: init-with-liveness
    image: nginx
    command: ['sh', '-c', 'nginx -g "daemon off;" & sleep 10']
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 2
      periodSeconds: 3
  containers:
  - name: app
    image: nginx
EOF

kubectl wait --for=condition=Ready pod init-with-probe --timeout=60s
kubectl describe pod init-with-probe | grep -A 5 "Liveness:"
```{{exec}}

Review probe behavior on init containers.
