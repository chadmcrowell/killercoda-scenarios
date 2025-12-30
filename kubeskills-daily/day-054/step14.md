## Step 14: Check certificate chain

```bash
kubectl get secret short-lived-tls -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -text | grep -A 5 "Issuer:"

kubectl get secret short-lived-tls -o jsonpath='{.data.tls\.crt}' | base64 -d > /tmp/cert.crt
kubectl get secret short-lived-tls -o jsonpath='{.data.ca\.crt}' | base64 -d > /tmp/ca.crt 2>/dev/null || echo "No CA cert"
openssl verify -CAfile /tmp/ca.crt /tmp/cert.crt 2>/dev/null || echo "Verification failed or no CA"
```{{exec}}

Inspect issuer and verify chain if CA is present.
