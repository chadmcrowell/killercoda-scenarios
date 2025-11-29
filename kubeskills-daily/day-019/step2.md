## Step 2: Disable automounting at pod level

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: no-token-pod
spec:
  automountServiceAccountToken: false
  containers:
  - name: app
    image: bitnami/kubectl:latest
    command: ['sleep', '3600']
EOF
```{{exec}}

```bash
kubectl exec no-token-pod -- ls /var/run/secrets/kubernetes.io/serviceaccount/ 2>&1
kubectl exec no-token-pod -- kubectl get pods
```{{exec}}

No token directory is present; kubectl fails with Unauthorized.
