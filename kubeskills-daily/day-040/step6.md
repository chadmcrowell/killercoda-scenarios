## Step 6: Check certificate secret

```bash
kubectl get secret short-lived-tls -o yaml

kubectl get secret short-lived-tls -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -text | grep -A 2 "Validity"
```{{exec}}

Decode the TLS secret to inspect certificate validity dates.
