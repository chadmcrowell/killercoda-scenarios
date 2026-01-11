## Step 18: Test StatefulSet with restricted

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: restricted-statefulset
  namespace: restricted-ns
spec:
  serviceName: restricted-svc
  replicas: 2
  selector:
    matchLabels:
      app: restricted-app
  template:
    metadata:
      labels:
        app: restricted-app
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        fsGroup: 1000
        seccompProfile:
          type: RuntimeDefault
      containers:
      - name: app
        image: nginx:latest
        securityContext:
          allowPrivilegeEscalation: false
          runAsNonRoot: true
          runAsUser: 1000
          capabilities:
            drop: ["ALL"]
          readOnlyRootFilesystem: true
        volumeMounts:
        - name: cache
          mountPath: /var/cache/nginx
        - name: run
          mountPath: /var/run
      volumes:
      - name: cache
        emptyDir: {}
      - name: run
        emptyDir: {}
EOF

kubectl get statefulset restricted-statefulset -n restricted-ns
kubectl get pods -n restricted-ns -l app=restricted-app
```{{exec}}

StatefulSets can run under restricted with correct securityContext.
