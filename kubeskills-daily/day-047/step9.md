## Step 9: Test PVC retention policy (K8s 1.27+)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web-with-retention
spec:
  serviceName: stateful-svc
  replicas: 2
  selector:
    matchLabels:
      app: retention-test
  persistentVolumeClaimRetentionPolicy:
    whenDeleted: Delete
    whenScaled: Retain
  template:
    metadata:
      labels:
        app: retention-test
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
```

```bash
kubectl wait --for=condition=Ready pods -l app=retention-test --timeout=60s
kubectl get pvc
kubectl delete statefulset web-with-retention
sleep 5
kubectl get pvc
```{{exec}}

On K8s 1.27+, PVCs delete when the StatefulSet is deleted, but scale-down still retains them.
