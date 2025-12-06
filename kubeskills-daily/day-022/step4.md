## Step 4: Try a wrong secret type

```bash
kubectl create secret generic broken-pull-secret \
  --from-literal=username=myuser \
  --from-literal=password=mypassword
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: wrong-secret-type
spec:
  imagePullSecrets:
  - name: broken-pull-secret
  containers:
  - name: app
    image: private-registry.example.com/myapp:v1.0
EOF
```{{exec}}

```bash
kubectl describe pod wrong-secret-type | grep -A 5 Events
```{{exec}}

Expect secret type mismatch or invalid format errors.
