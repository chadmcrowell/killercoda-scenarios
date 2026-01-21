## Step 6: Use imagePullSecret in pod

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: with-pull-secret
spec:
  imagePullSecrets:
  - name: my-registry-secret
  containers:
  - name: app
    image: private-registry.example.com/myapp:v1.0
EOF

# Still fails (registry doesn't exist), but shows proper auth attempt
sleep 10
kubectl describe pod with-pull-secret | grep -A 5 "Events:"
```{{exec}}

Confirm the secret is used during pull attempts.
