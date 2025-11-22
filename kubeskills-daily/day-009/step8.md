## Step 8: Force pod restart on ConfigMap change

Option A: annotation hash trigger.

```bash
kubectl delete pod subpath-test
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: config-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: config-app
  template:
    metadata:
      labels:
        app: config-app
      annotations:
        # Change this value to force restart
        configmap-hash: "v1"
    spec:
      containers:
      - name: app
        image: busybox
        command: ['sh', '-c', 'echo "APP_MODE=$APP_MODE"; sleep 3600']
        env:
        - name: APP_MODE
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: APP_MODE
EOF
```{{exec}}

```bash
kubectl patch deployment config-app -p '{"spec":{"template":{"metadata":{"annotations":{"configmap-hash":"v2"}}}}}'
```{{exec}}

```bash
kubectl rollout status deployment config-app
kubectl logs -l app=config-app
```{{exec}}

Changing the annotation forces a new ReplicaSet, picking up the new ConfigMap values.
