## Step 10: Test parallel pod management

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: parallel-web
spec:
  serviceName: parallel-svc
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
EOF

sleep 30

kubectl get events --sort-by='.lastTimestamp' | grep "parallel-web" | grep Created | head -5

echo ""
echo "Parallel pod management:"
echo "- All pods created simultaneously"
echo "- No ordering guarantee"
echo "- Faster startup"
echo "- Use for stateless workloads in StatefulSet"
```{{exec}}

`podManagementPolicy: Parallel` creates all pods simultaneously — faster startup but no ordering guarantees. Use this only when your application doesn't depend on peer readiness during init.
