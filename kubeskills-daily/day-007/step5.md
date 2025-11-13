## Step 5: Change restart policy to Never

```bash
kubectl delete pod fixed-pod
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: no-restart-pod
spec:
  restartPolicy: Never
  initContainers:
  - name: wait-for-db
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      for i in $(seq 1 5); do
        if nslookup nonexistent-db; then exit 0; fi
        echo "Attempt $i/5 failed"
        sleep 2
      done
      exit 1
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl get pods no-restart-pod
```{{exec}}

Pod stays `Init:Error`—no retries when `restartPolicy: Never`.
