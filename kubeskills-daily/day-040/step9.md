## Step 9: Test expired certificate simulation

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: expired-cert
spec:
  secretName: expired-tls
  duration: 1h
  renewBefore: 59m
  issuerRef:
    name: selfsigned-issuer
  dnsNames:
  - expired.example.com
EOF
```{{exec}}

```bash
kubectl get certificate expired-cert -w
```{{exec}}

cert-manager should continuously renew the expiring cert.
