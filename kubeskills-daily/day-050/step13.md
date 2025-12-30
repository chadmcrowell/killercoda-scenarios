## Step 13: Test eviction with custom toleration

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: fast-eviction
spec:
  tolerations:
  - key: node.kubernetes.io/not-ready
    operator: Exists
    effect: NoExecute
    tolerationSeconds: 10
  containers:
  - name: nginx
    image: nginx
EOF

kubectl taint nodes $NODE node.kubernetes.io/not-ready:NoExecute --overwrite
kubectl get pod fast-eviction -w
```{{exec}}

Custom tolerationSeconds evicts the pod in ~10 seconds.
