## Step 12: Test readiness probe vs init container

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: readiness-vs-init
spec:
  initContainers:
  - name: quick-init
    image: busybox
    command: ['sh', '-c', 'echo "Init complete"; sleep 2']
  containers:
  - name: app
    image: hashicorp/http-echo
    args: ["-text=Ready"]
    ports:
    - containerPort: 5678
    readinessProbe:
      httpGet:
        path: /
        port: 5678
      initialDelaySeconds: 5
      periodSeconds: 2
EOF
```{{exec}}

```bash
kubectl get pod readiness-vs-init -w
```{{exec}}

Watch Init -> Running (not Ready) -> Ready to see how readiness follows init completion.
