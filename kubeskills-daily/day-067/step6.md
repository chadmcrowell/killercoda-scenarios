## Step 6: Test init container dependency

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-dependency
spec:
  initContainers:
  - name: wait-for-db
    image: busybox
    command:
    - sh
    - -c
    - |
      echo "Waiting for database..."
      until nslookup mysql.default.svc.cluster.local; do
        echo "Database not ready, waiting..."
        sleep 2
      done
      echo "Database ready!"
  containers:
  - name: app
    image: nginx
EOF

# Stuck because mysql service doesn't exist
sleep 15
kubectl get pod init-dependency
kubectl logs init-dependency -c wait-for-db --tail=10
```{{exec}}

Wait on a dependency that is not ready yet.
