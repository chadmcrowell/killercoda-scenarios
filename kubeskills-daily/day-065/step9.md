## Step 9: Test missing image tag (defaults to :latest)

```bash
kubectl run no-tag --image=nginx  # Implicitly :latest

kubectl get pod no-tag -o jsonpath='{.spec.containers[0].image}'
echo ""
```{{exec}}

Confirm that missing tags default to :latest.
