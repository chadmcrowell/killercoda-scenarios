## Step 8: Create webhook certificate

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: webhook-cert
spec:
  secretName: webhook-tls
  duration: 8760h
  renewBefore: 360h
  issuerRef:
    name: selfsigned-issuer
  dnsNames:
  - webhook-service.default.svc
  - webhook-service.default.svc.cluster.local
EOF
```{{exec}}

A year-long cert for the webhook service with a 15-day renewal window.
