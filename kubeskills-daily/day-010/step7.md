## Step 7: Secret with automatic rotation trigger

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rotating-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: rotating-app
  template:
    metadata:
      labels:
        app: rotating-app
      annotations:
        secret-version: "v1"
    spec:
      containers:
      - name: app
        image: busybox
        command: ['sh', '-c', 'echo "Starting with password: $DB_PASS"; sleep 3600']
        env:
        - name: DB_PASS
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: password
EOF
```{{exec}}

```bash
# Update secret
kubectl patch secret db-credentials -p '{"stringData":{"password":"finalpassword000"}}'

# Trigger deployment rollout
kubectl patch deployment rotating-app -p '{"spec":{"template":{"metadata":{"annotations":{"secret-version":"v2"}}}}}'

kubectl rollout status deployment rotating-app
kubectl logs -l app=rotating-app
```{{exec}}

Bumping the annotation forces a new ReplicaSet so pods pick up the rotated secret.
