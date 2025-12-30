## Step 13: Test manual certificate renewal

```bash
kubectl delete secret short-lived-tls
sleep 10
kubectl get secret short-lived-tls
kubectl get certificate short-lived-cert
```{{exec}}

Deleting the secret forces cert-manager to recreate it.
