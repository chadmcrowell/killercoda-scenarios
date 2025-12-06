## Step 10: See cross-namespace secret failure

```bash
kubectl create namespace team-a
kubectl create namespace team-b
```{{exec}}

```bash
kubectl create secret docker-registry team-a-secret \
  -n team-a \
  --docker-server=registry.example.com \
  --docker-username=user \
  --docker-password=pass
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cross-namespace-fail
  namespace: team-b
spec:
  imagePullSecrets:
  - name: team-a-secret
  containers:
  - name: app
    image: registry.example.com/private:latest
EOF
```{{exec}}

```bash
kubectl describe pod cross-namespace-fail -n team-b | grep -A 5 Events
```{{exec}}

Secrets are namespace-scoped, so this shows a secret not found error.
