## Step 4: Create short-lived certificate

```bash
kubectl get pods -n cert-manager 2>/dev/null || echo "cert-manager not installed"

cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: test-issuer
spec:
  selfSigned: {}
EOF

cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: short-lived-cert
spec:
  secretName: short-lived-tls
  duration: 1h
  renewBefore: 30m
  issuerRef:
    name: test-issuer
  dnsNames:
  - test.example.com
EOF

kubectl get certificate short-lived-cert
kubectl describe certificate short-lived-cert
```{{exec}}

Issue a short-lived cert to exercise renewal.
