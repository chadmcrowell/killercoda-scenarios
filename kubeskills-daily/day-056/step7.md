## Step 7: Test DaemonSet ignores capacity

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: resource-daemon
  namespace: capacity-test
spec:
  selector:
    matchLabels:
      app: daemon
  template:
    metadata:
      labels:
        app: daemon
    spec:
      containers:
      - name: app
        image: nginx
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
EOF

# Check DaemonSet pods scheduled despite capacity
kubectl get pods -n capacity-test -l app=daemon -o wide
```

DaemonSets schedule on every node regardless of free capacity.
