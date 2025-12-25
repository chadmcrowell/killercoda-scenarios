## Step 8: Test cascade deletion (PVCs still remain)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: stateful-svc
  replicas: 2
  selector:
    matchLabels:
      app: stateful
  template:
    metadata:
      labels:
        app: stateful
    spec:
      containers:
      - name: nginx
        image: nginx
        volumeMounts:
        - name: data
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
EOF

kubectl wait --for=condition=Ready pods -l app=stateful --timeout=60s
kubectl delete statefulset web --cascade=foreground
kubectl get pvc
```{{exec}}

Even with foreground cascade, PVCs remain.
