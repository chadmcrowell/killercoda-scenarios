## Step 10: Test ResourceQuota violation

```bash
# Try to exceed Team B's pod quota (limit: 5)
cat <<'APP' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: quota-buster
  namespace: team-b
spec:
  replicas: 10  # Exceeds quota!
  selector:
    matchLabels:
      app: buster
  template:
    metadata:
      labels:
        app: buster
    spec:
      containers:
      - name: nginx
        image: nginx
        resources:
          requests:
            cpu: 50m
            memory: 64Mi
APP
```

```bash
kubectl get deployment quota-buster -n team-b
kubectl get replicaset -n team-b
```{{exec}}

Only 5 pods should be created—quota enforced.
