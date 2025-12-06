## Step 2: Deploy baseline pods with networking

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nettest-1
  labels:
    app: nettest
spec:
  containers:
  - name: netshoot
    image: nicolaka/netshoot
    command: ['sleep', '3600']
---
apiVersion: v1
kind: Pod
metadata:
  name: nettest-2
  labels:
    app: nettest
spec:
  containers:
  - name: netshoot
    image: nicolaka/netshoot
    command: ['sleep', '3600']
EOF
```{{exec}}

```bash
kubectl get pods -o wide
```{{exec}}

Both pods should have IPs assigned.
