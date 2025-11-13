## Step 6: Test time-based eviction

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: temporary-toleration
spec:
  tolerations:
  - key: "dedicated"
    operator: "Equal"
    value: "gpu"
    effect: "NoExecute"
    tolerationSeconds: 30
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    kubernetes.io/hostname: $NODE
EOF
```{{exec}}

```bash
kubectl get pod temporary-toleration -w
```{{exec}}

Pod runs, then gets Terminating ~30s later as the toleration expires.
