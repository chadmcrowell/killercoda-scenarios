## Step 1: Check existing CRDs

```bash
kubectl get crds
kubectl api-resources | grep -i custom
```{{exec}}

Confirm baseline CRDs and API resources before creating your own.
