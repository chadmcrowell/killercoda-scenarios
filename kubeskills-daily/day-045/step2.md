## Step 2: Try normal exec (fails!)

```bash
kubectl exec minimal-app -- sh
```{{exec}}

Expect error: no shell in distroless image.
