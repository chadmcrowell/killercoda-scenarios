## Step 4: Watch endpoint propagation

```bash
kubectl get endpoints backend-svc -w
```{{exec}}

Observe when endpoints appear—only after pods become Ready. Stop watching once you see the addresses populate.
