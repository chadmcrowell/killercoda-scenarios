## Step 4: Create self-signed Issuer

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
EOF
```{{exec}}

Create a basic self-signed Issuer for testing renewals.
