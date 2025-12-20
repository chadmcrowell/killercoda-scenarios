## Step 14: Check certificate readiness

```bash
kubectl get certificate -A
kubectl get certificaterequest -A
kubectl get order -A
```{{exec}}

Check status across all namespaces (orders appear for ACME issuers).
