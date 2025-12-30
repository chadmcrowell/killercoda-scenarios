## Step 3: Review cert-manager certificates

```bash
kubectl get certificate -A
kubectl get certificate -A -o custom-columns=\
NAMESPACE:.metadata.namespace,\
NAME:.metadata.name,\
READY:.status.conditions[0].status,\
EXPIRATION:.status.notAfter
```{{exec}}

List cert-manager certificates and their expiration times.
