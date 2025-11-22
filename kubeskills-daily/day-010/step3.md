## Step 3: Rotate the password

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
type: Opaque
stringData:
  username: admin
  password: newsecurepassword456
  connection-string: "postgresql://admin:newsecurepassword456@db:5432/myapp"
EOF
```{{exec}}

Keep watching the `secret-app` logs for ~90 seconds: env var stays `supersecret123`, while the mounted file updates to `newsecurepassword456` after ~60s.
