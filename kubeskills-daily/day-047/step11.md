## Step 11: Test parallel pod management

```bash
kubectl delete statefulset web
kubectl delete pvc --all

cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: parallel-web
spec:
  serviceName: stateful-svc
  replicas: 3
  podManagementPolicy: Parallel
  selector:
    matchLabels:
      app: parallel
  template:
    metadata:
      labels:
        app: parallel
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
```{{exec}}

```bash
kubectl get pods -l app=parallel -w
```{{exec}}

Parallel pod management starts all pods simultaneously.
