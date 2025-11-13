## Step 4: Add a timeout with retries

```bash
kubectl delete pod blocked-pod
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: fixed-pod
spec:
  initContainers:
  - name: wait-for-db
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      for i in $(seq 1 10); do
        if nslookup nonexistent-db; then
          echo "Service found!"
          exit 0
        fi
        echo "Attempt $i/10 failed, retrying..."
        sleep 3
      done
      echo "Service not found after 10 attempts, giving up"
      exit 1
  containers:
  - name: app
    image: nginx
    ports:
    - containerPort: 80
EOF
```{{exec}}

```bash
kubectl get pods fixed-pod -w
```{{exec}}

After ~30s the init container exits 1, so the pod enters CrashLoopBackOff (due to `restartPolicy: Always`).
