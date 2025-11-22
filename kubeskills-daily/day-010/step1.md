## Step 1: Create initial secrets

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
type: Opaque
stringData:
  username: admin
  password: supersecret123
  connection-string: "postgresql://admin:supersecret123@db:5432/myapp"
EOF
```{{exec}}

```bash
kubectl get secret db-credentials -o jsonpath='{.data.password}' | base64 -d
echo ""
```{{exec}}

Confirm the secret exists and the password decodes to `supersecret123`.
