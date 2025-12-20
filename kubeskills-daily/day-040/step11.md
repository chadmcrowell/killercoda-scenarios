## Step 11: Restore issuer

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
EOF

kubectl get certificate short-lived-cert -w
```{{exec}}

Restoring the issuer allows certificates to renew again.
