## Step 12: Test RollingUpdate with partition

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: partition-web
spec:
  serviceName: partition-svc
  replicas: 4
  updateStrategy:
    type: RollingUpdate
    rollingUpdate:
      partition: 2
  selector:
    matchLabels:
      app: partition
  template:
    metadata:
      labels:
        app: partition
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
EOF

kubectl wait --for=condition=Ready pod -l app=partition --timeout=90s
```{{exec}}

```bash
kubectl patch statefulset partition-web -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","image":"nginx:1.22"}]}}}}'

sleep 30
```{{exec}}

```bash
echo "Pod images after update with partition=2:"
for i in 0 1 2 3; do
  IMAGE=$(kubectl get pod partition-web-$i -o jsonpath='{.spec.containers[0].image}')
  echo "partition-web-$i: $IMAGE"
done

echo ""
echo "Only pods 2 and 3 updated (ordinal >= partition)"
```{{exec}}

A rolling update `partition` acts as a canary gate — only pods with ordinal >= partition value receive the update. Lower-ordinal pods stay on the old version until the partition is removed.
