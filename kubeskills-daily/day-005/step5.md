## Step 5: Add a matching toleration

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: with-toleration
spec:
  tolerations:
  - key: "dedicated"
    operator: "Equal"
    value: "gpu"
    effect: "NoExecute"
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    kubernetes.io/hostname: $NODE
EOF
```{{exec}}

```bash
kubectl get pod with-toleration -o wide
```{{exec}}

This pod schedules successfully on the tainted node.
