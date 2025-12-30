## Step 11: Test expired certificate handling

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: expire-test
spec:
  secretName: expire-test-tls
  duration: 2m
  renewBefore: 1m
  issuerRef:
    name: test-issuer
  dnsNames:
  - expire.example.com
EOF

kubectl wait --for=condition=Ready certificate/expire-test --timeout=60s

echo "Waiting for expiration..."
sleep 130

kubectl get secret expire-test-tls -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -checkend 0 && echo "Valid" || echo "Expired!"
```{{exec}}

Short-lived cert expires quickly to test detection/renewal.
