## Step 11: Test OnDelete update strategy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: ondelete-web
spec:
  serviceName: ondelete-svc
  replicas: 2
  updateStrategy:
    type: OnDelete
  selector:
    matchLabels:
      app: ondelete
  template:
    metadata:
      labels:
        app: ondelete
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
EOF

kubectl wait --for=condition=Ready pod -l app=ondelete --timeout=60s
```{{exec}}

```bash
kubectl patch statefulset ondelete-web -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","image":"nginx:1.22"}]}}}}'

sleep 10
```{{exec}}

```bash
kubectl get pods -l app=ondelete -o jsonpath='{.items[*].spec.containers[0].image}'
echo ""
echo "Pods still running nginx:1.21 (OnDelete requires manual pod deletion)"
```{{exec}}

```bash
kubectl delete pod ondelete-web-0

kubectl wait --for=condition=Ready pod ondelete-web-0 --timeout=60s

kubectl get pod ondelete-web-0 -o jsonpath='{.spec.containers[0].image}'
echo " (updated)"
kubectl get pod ondelete-web-1 -o jsonpath='{.spec.containers[0].image}'
echo " (not updated)"
```{{exec}}

With `updateStrategy: OnDelete`, image updates only take effect when you manually delete the pod. This gives full control over when each pod picks up the new version.
