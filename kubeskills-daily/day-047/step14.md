## Step 14: StatefulSet with init containers

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: init-web
spec:
  serviceName: stateful-svc
  replicas: 2
  selector:
    matchLabels:
      app: init-test
  template:
    metadata:
      labels:
        app: init-test
    spec:
      initContainers:
      - name: setup
        image: busybox
        command: ['sh', '-c', 'echo "Initialized by init container" > /data/init.txt']
        volumeMounts:
        - name: data
          mountPath: /data
      containers:
      - name: nginx
        image: nginx
        volumeMounts:
        - name: data
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
EOF

kubectl wait --for=condition=Ready pods -l app=init-test --timeout=60s
kubectl exec init-web-0 -- cat /usr/share/nginx/html/init.txt
```{{exec}}

Init container seeds data into each PVC before the main container runs.
