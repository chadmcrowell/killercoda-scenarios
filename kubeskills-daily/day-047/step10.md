## Step 10: Test PVC expansion

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: stateful-svc
  replicas: 1
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
kubectl patch pvc data-web-0 -p '{"spec":{"resources":{"requests":{"storage":"2Gi"}}}}'

kubectl get pvc data-web-0 -o jsonpath='{.status.capacity.storage}'
```{{exec}}

Check storage class allows expansion and the new capacity is reflected.
