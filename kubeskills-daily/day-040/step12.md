## Step 12: Test CA certificate

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ca-cert
spec:
  isCA: true
  commonName: my-ca
  secretName: ca-secret
  duration: 43800h
  issuerRef:
    name: selfsigned-issuer
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: ca-issuer
spec:
  ca:
    secretName: ca-secret
EOF
```{{exec}}

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: app-cert
spec:
  secretName: app-tls
  duration: 2160h
  renewBefore: 360h
  issuerRef:
    name: ca-issuer
  dnsNames:
  - app.example.com
EOF
```{{exec}}

```bash
kubectl get secret app-tls -o jsonpath='{.data.ca\.crt}' | base64 -d | openssl x509 -noout -subject
```{{exec}}

Issue a CA and sign another cert from it, then check the chain.
