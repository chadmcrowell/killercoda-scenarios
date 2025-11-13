## Step 1: Deploy a pod that never unblocks

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: blocked-pod
spec:
  initContainers:
  - name: wait-for-db
    image: busybox
    command: ['sh', '-c', 'until nslookup nonexistent-db; do echo waiting; sleep 2; done']
  containers:
  - name: app
    image: nginx
    ports:
    - containerPort: 80
EOF
```{{exec}}

```bash
kubectl get pods blocked-pod -w
```{{exec}}

Status stays `Init:0/1` forever because the DNS lookup never succeeds.
