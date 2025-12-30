## Step 12: Check for alpha APIs (unstable)

```bash
kubectl api-resources | grep -E "alpha|v[0-9]+alpha[0-9]+"

kubectl get all -A -o json | jq -r '.items[] | select(.apiVersion | contains("alpha")) | "\(.kind): \(.apiVersion)"' 2>/dev/null || echo "No alpha APIs in use"
```{{exec}}

Alpha APIs may disappear between releases.
