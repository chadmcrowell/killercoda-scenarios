## Step 3: Deploy privileged pod

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: privileged-pod
  namespace: privileged-ns
spec:
  containers:
  - name: app
    image: nginx
    securityContext:
      privileged: true
      runAsUser: 0
      capabilities:
        add: ["SYS_ADMIN", "NET_ADMIN"]
EOF

# Check status
kubectl get pod privileged-pod -n privileged-ns
```{{exec}}

Privileged profile allows everything.
