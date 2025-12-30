## Step 9: Test StatefulSet behavior during partition

```bash
kubectl delete networkpolicy --all
kubectl delete statefulset split-test
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: split-test
spec:
  serviceName: split-test-svc
  replicas: 2
  selector:
    matchLabels:
      app: split-test
  template:
    metadata:
      labels:
        app: split-test
    spec:
      containers:
      - name: app
        image: nginx
        command: ['sh', '-c', 'hostname > /usr/share/nginx/html/index.html; nginx -g "daemon off;"']
EOF

kubectl wait --for=condition=Ready pods -l app=split-test --timeout=60s
```{{exec}}

Recreate the StatefulSet after clearing policies.
