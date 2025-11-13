## Step 4: Schedule a pod without toleration

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: no-toleration
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    kubernetes.io/hostname: $NODE
EOF
```{{exec}}

```bash
kubectl get pod no-toleration
```{{exec}}

```bash
kubectl describe pod no-toleration | grep -A 3 Events
```{{exec}}

Status remains Pending because the node has an untolerated taint.
