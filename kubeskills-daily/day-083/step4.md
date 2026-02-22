## Step 4: Test volume attachment failure

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: broken-storage
spec:
  serviceName: broken-svc
  replicas: 1
  selector:
    matchLabels:
      app: broken
  template:
    metadata:
      labels:
        app: broken
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
      storageClassName: nonexistent-class
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
EOF

sleep 20
```{{exec}}

```bash
kubectl get pods -l app=broken
kubectl get pvc -l app=broken

echo ""
echo "Pod stuck: Volume provisioning failed"
kubectl describe pod -l app=broken | grep -A 5 "Events:"
```{{exec}}

A StatefulSet referencing a non-existent StorageClass leaves its pod stuck in Pending — the PVC can never be provisioned, blocking pod scheduling entirely.
