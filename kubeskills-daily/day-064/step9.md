## Step 9: Test StatefulSet with broken storage

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: stateful-svc
spec:
  clusterIP: None
  selector:
    app: stateful
  ports:
  - port: 80
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: broken-statefulset
spec:
  serviceName: stateful-svc
  replicas: 3
  selector:
    matchLabels:
      app: stateful
  template:
    metadata:
      labels:
        app: stateful
    spec:
      containers:
      - name: app
        image: nginx
        volumeMounts:
        - name: data
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      storageClassName: broken-storage  # Broken!
      resources:
        requests:
          storage: 1Gi
EOF

# Check status
sleep 10
kubectl get statefulset broken-statefulset
kubectl get pods -l app=stateful
kubectl get pvc -l app=stateful
```{{exec}}

See how bad storage classes block StatefulSet scaling.
