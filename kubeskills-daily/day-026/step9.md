## Step 9: Check pod priority values

```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,PRIORITY:.spec.priority
```{{exec}}

Confirm priorities applied.
