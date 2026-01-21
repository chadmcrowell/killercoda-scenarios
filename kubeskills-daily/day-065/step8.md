## Step 8: Test image pull policy

```bash
# Always pull (ignores local cache)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: always-pull
spec:
  containers:
  - name: app
    image: nginx:latest
    imagePullPolicy: Always  # Always pulls, even if cached
EOF

# Never pull (fails if not cached)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: never-pull
spec:
  containers:
  - name: app
    image: nginx:nonexistent-987654
    imagePullPolicy: Never  # Never pulls
EOF

sleep 10
kubectl describe pod never-pull | grep -A 5 "Events:"
```{{exec}}

Compare Always vs Never image pull behavior.
