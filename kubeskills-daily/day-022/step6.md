## Step 6: Test a public registry that requires auth

```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=myuser \
  --docker-password=mypassword \
  --docker-email=user@example.com
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: ghcr-test
spec:
  imagePullSecrets:
  - name: ghcr-secret
  containers:
  - name: app
    image: ghcr.io/private-org/private-repo:latest
EOF
```{{exec}}

```bash
kubectl describe pod ghcr-test | grep -A 5 Events
```{{exec}}

Without real credentials this still fails, showing unauthorized or denied errors.
