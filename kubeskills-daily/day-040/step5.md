## Step 5: Create Certificate with short expiration

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: short-lived-cert
spec:
  secretName: short-lived-tls
  duration: 24h
  renewBefore: 12h
  issuerRef:
    name: selfsigned-issuer
  dnsNames:
  - example.com
  - www.example.com
EOF
```{{exec}}

```bash
kubectl get certificate short-lived-cert
kubectl describe certificate short-lived-cert
```{{exec}}

Certificate is short-lived and renews when 12h remain.
