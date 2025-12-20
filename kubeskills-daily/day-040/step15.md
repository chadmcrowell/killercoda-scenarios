## Step 15: Debug certificate issues

```bash
kubectl logs -n cert-manager -l app=cert-manager --tail=50
kubectl describe certificate short-lived-cert
kubectl get secret short-lived-tls -o yaml
kubectl get secret short-lived-tls -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -text
```{{exec}}

Use logs, events, secrets, and OpenSSL to troubleshoot certificate problems.
