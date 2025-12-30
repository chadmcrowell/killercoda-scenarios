## Step 9: StatefulSet stuck in Terminating

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: stateful-svc
spec:
  clusterIP: None
  selector:
    app: stateful
  ports:
  - port: 80
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: stateful-app
spec:
  serviceName: stateful-svc
  replicas: 3
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
EOF

kubectl wait --for=condition=Ready pods -l app=stateful --timeout=60s
STATEFUL_NODE=$(kubectl get pod stateful-app-0 -o jsonpath='{.spec.nodeName}')
kubectl taint nodes $STATEFUL_NODE node.kubernetes.io/unreachable:NoExecute --overwrite
kubectl get pods -l app=stateful -w
```{{exec}}

Stateful pods can stick Terminating when their node is unreachable.
