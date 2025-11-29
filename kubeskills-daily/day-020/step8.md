## Step 8: Test infinite toleration

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: immortal-pod
spec:
  tolerations:
  - key: node.kubernetes.io/not-ready
    operator: Exists
    effect: NoExecute
    # No tolerationSeconds = wait forever
  - key: node.kubernetes.io/unreachable
    operator: Exists
    effect: NoExecute
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    kubernetes.io/hostname: $NODE
EOF
```{{exec}}

This pod sticks to the tainted node indefinitely.
