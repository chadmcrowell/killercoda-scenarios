## Step 6: Test parallel pod management

Clean up the ordered StatefulSet and recreate it with `podManagementPolicy: Parallel` to remove the sequencing requirement.

```bash
kubectl delete statefulset web

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 3
  podManagementPolicy: Parallel
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF
```{{exec}}

**Watch the difference:**

```bash
kubectl get pods -l app=nginx -w
```{{exec}}

All three pods start simultaneously—no ordering guarantees!
