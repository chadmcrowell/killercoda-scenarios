## Step 11: Test DNS caching

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: cache-test
spec:
  selector:
    app: cache-test
  ports:
  - port: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cache-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cache-test
  template:
    metadata:
      labels:
        app: cache-test
    spec:
      containers:
      - name: app
        image: nginx
EOF
```{{exec}}

```bash
kubectl run resolver --rm -it --restart=Never --image=busybox -- sh -c '
for i in $(seq 1 5); do
  echo "Query $i:";
  nslookup cache-test;
  sleep 1;
done
'
```{{exec}}

Repeated queries should hit cache between TTL refreshes.
