## Step 10: Check CA certificate

```bash
kubectl get secret short-lived-tls -o jsonpath='{.data.ca\.crt}' | base64 -d | openssl x509 -noout -dates 2>/dev/null || echo "No CA in secret"
kubectl get cm kube-root-ca.crt -o jsonpath='{.data.ca\.crt}' | openssl x509 -noout -dates
```{{exec}}

Inspect CA from cert-manager secret and the cluster root CA ConfigMap.
