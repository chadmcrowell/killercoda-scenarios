## Step 4: Create test application to backup

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: backup-test
  labels:
    app: test
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-app
  namespace: backup-test
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        volumeMounts:
        - name: data
          mountPath: /usr/share/nginx/html
      volumes:
      - name: data
        emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  namespace: backup-test
spec:
  selector:
    app: nginx
  ports:
  - port: 80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: backup-test
data:
  config.json: |
    {"environment": "production"}
---
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
  namespace: backup-test
type: Opaque
stringData:
  password: "super-secret-password"
EOF

for pod in $(kubectl get pods -n backup-test -l app=nginx -o name); do
  kubectl exec -n backup-test $pod -- sh -c 'echo "Important data" > /usr/share/nginx/html/index.html'
done
```{{exec}}

App data written to emptyDir in each pod.
