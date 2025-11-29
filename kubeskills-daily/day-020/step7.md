## Step 7: Test custom toleration (longer wait)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: patient-pod
spec:
  tolerations:
  - key: node.kubernetes.io/not-ready
    operator: Exists
    effect: NoExecute
    tolerationSeconds: 600
  - key: node.kubernetes.io/unreachable
    operator: Exists
    effect: NoExecute
    tolerationSeconds: 600
  containers:
  - name: nginx
    image: nginx
EOF
```{{exec}}

```bash
kubectl taint nodes $NODE node.kubernetes.io/not-ready:NoExecute
kubectl get pods -w
```{{exec}}

Patient pod waits 10 minutes before eviction; others leave quickly.
