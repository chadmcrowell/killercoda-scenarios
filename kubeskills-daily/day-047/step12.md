## Step 12: Test StatefulSet update strategies

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: rolling-update
spec:
  serviceName: stateful-svc
  replicas: 3
  updateStrategy:
    type: RollingUpdate
    rollingUpdate:
      partition: 2
  selector:
    matchLabels:
      app: rolling
  template:
    metadata:
      labels:
        app: rolling
        version: v1
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
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

kubectl wait --for=condition=Ready pods -l app=rolling --timeout=120s
kubectl patch statefulset rolling-update -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","image":"nginx:1.26"}]}}}}'

kubectl get pods -l app=rolling -o jsonpath='{range .items[*]}{.metadata.name}\t{.spec.containers[0].image}{"\n"}{end}'
```{{exec}}

Partition 2 updates only pod ordinals >= 2.
